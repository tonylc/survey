class Family < ActiveRecord::Base
  has_one :family_reporter
  has_many :users, :dependent => :destroy

  validates_presence_of :business_name, :num_users

  def validates_ability_to_add_new_members
    raise ActiveRecord::RecordNotSaved.new("You have reached your family member quota.  Please contact RelativeSolutions to add more family members.") unless self.users.size < self.num_users
  end

  def count_completed_surveys
    # should be safe to do, since it must be an integer from the db
    User.count_by_sql("select count(*) from users, surveys where users.family_id = #{self.id} and surveys.user_id = users.id and surveys.page_complete = #{APP_CONFIG["number_of_pages"]}")
  end
end
