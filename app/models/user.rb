require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  belongs_to :family
  has_one :survey
  has_one :survey_answer, :through => :survey

  validates_presence_of     :last_name, :first_name,                      :if => :only_if_not_admin
  validates_presence_of     :login, :on => :update
  validates_presence_of     :email
  validates_format_of       :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_presence_of     :password, :on => :update,                    :if => :password_required?
  validates_presence_of     :password_confirmation, :on => :update,       :if => :password_required?
  validates_length_of       :password, :within => 4..40, :on => :update,  :if => :password_required?
  validates_confirmation_of :password, :on => :update,                    :if => :password_required?
  validates_length_of       :login, :within => 3..40, :on => :update
  validates_length_of       :email, :within => 3..100
  validates_uniqueness_of   :login, :on => :update
  #validates_uniqueness_of   :email, :case_sensitive => false, :message => "This email has already been registered, please select another email address."
  before_create :make_activation_code
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :last_name, :first_name, :login, :email, :password, :password_confirmation

  acts_as_state_machine :initial => :pending
  state :passive
  state :pending#, :enter => :make_activation_code
  state :active,  :enter => :do_activate
  state :suspended
  state :deleted, :enter => :do_delete

  event :register do
    transitions :from => :passive, :to => :pending#, :guard => Proc.new {|u| !(u.crypted_password.blank? && u.password.blank?) }
  end
  
  event :activate do
    transitions :from => :pending, :to => :active 
  end
  
  event :suspend do
    transitions :from => [:passive, :pending, :active], :to => :suspended
  end
  
  event :delete do
    transitions :from => [:passive, :pending, :active, :suspended], :to => :deleted
  end

  event :unsuspend do
    transitions :from => :suspended, :to => :active,  :guard => Proc.new {|u| !u.activated_at.blank? }
    transitions :from => :suspended, :to => :pending, :guard => Proc.new {|u| !u.activation_code.blank? }
    transitions :from => :suspended, :to => :passive
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_in_state :first, :active, :conditions => {:login => login} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  def reset_password
    # First update the password_reset_code before setting the 
    # reset_password flag to avoid duplicate email notifications.
    update_attributes(:password_reset_code => nil)
    @reset_password = true
  end  

  #used in user_observer
  def recently_forgot_password?
    @forgotten_password
  end
  
  def recently_reset_password?
    @reset_password
  end
  
  def recently_activated?
    @recent_active
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def survey_complete?
    self.survey.nil? ? false : self.survey.page_complete == APP_CONFIG["number_of_pages"]
  end
  
  def has_family?
     self.is_admin? ? true : family.count_completed_surveys > 1
  end

  def survey_status
    if self.survey.nil?
      return "Unopened"
    else
      return self.survey.status
    end
  end

  def is_admin?
    return false
  end
  
  def only_if_not_admin
    !is_admin?
  end

  def is_family_reporter?
    return false
  end
  
  def get_survey
    self.is_admin? ? Survey.new : self.survey
  end
  
  def get_survey_answer
    self.is_admin? ? SurveyAnswer.mock : self.survey.survey_answer
  end
  
  def get_family_answer
    self.is_admin? ? SurveyAnswer.mock : SurveyAnswer.find(:first, :conditions => {:family_id => self.family_id})
  end
  
  def get_num_family_completed_surveys
    self.is_admin? ? 2 : self.family.count_completed_surveys
  end

  def find_all_family_members
    family_members = User.find(:all, :conditions => {:family_id => self.family_id}, :include => {:survey => :survey_answer})

    family_members = family_members.delete_if do |family_member|
      family_member.survey.nil? || !family_member.survey.all_pages_complete?
    end
  end
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_activation_code
      self.deleted_at = nil
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
    def do_delete
      self.deleted_at = Time.now.utc
    end

    def do_activate
      self.activated_at = Time.now.utc
      self.deleted_at = self.activation_code = nil
    end
    
    def make_password_reset_code
      self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
end
