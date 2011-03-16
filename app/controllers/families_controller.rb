class FamiliesController < ApplicationController

  before_filter :authenticate_admin_or_family_reporter, :only => [:edit, :update, :show]
  before_filter :authenticate_admin, :only => [:index, :new, :create]

  # GET /families
  # GET /families.xml
  def index
    @families = Family.find(:all, :select => "id, business_name", :order => "business_name ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @families }
    end
  end

  # GET /families/1
  # GET /families/1.xml
  def show
    if current_user.is_family_reporter? && (params[:id] != current_user.family_id.to_s)
      flash[:error] = "You do not have permission to access this page."
      redirect_to home_path
    else
      @family = Family.find(params[:id], :include => [:users])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @family }
      end
    end
  end

  # GET /families/new
  # GET /families/new.xml
  def new
    if request.post?

      @last_name = params[:last_name]
      @first_name = params[:first_name]
      @login = params[:login]
      @email = params[:email]
      @business_name = params[:business_name]
      @mailing_address = params[:mailing_address]
      @city = params[:city]
      @state = params[:state]
      @zip_code = params[:zip_code]
      @phone_number = params[:phone_number]
      @num_users = params[:num_users]
      @num_generations = params[:num_generations]

      begin
        Family.transaction do
          family_reporter = FamilyReporter.new(:last_name => params[:last_name], :first_name => params[:first_name],
                                              :login => params[:login], :email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
          family = Family.new(:business_name => @business_name, :mailing_address => @mailing_address, :city => @city, :state => @state, :zip_code => @zip_code, :phone_number => @phone_number, :num_users => @num_users, :num_generations => @num_generations)

          family_reporter.family = family
          family_reporter.save!
          family_reporter.register!
          family.save!
        end

        flash[:notice] = "New family for #{@business_name} added!"
        redirect_to :action => :index
      rescue Exception => e
        flash[:error] = "Error #{e.message}"
      end
    end
  end

  # GET /families/1/edit
  def edit
    @family = Family.find(params[:id])
  end

  # POST /families
  # POST /families.xml
  def create
    @family = Family.new(params[:family])

    respond_to do |format|
      if @family.save
        flash[:notice] = 'Family was successfully created.'
        format.html { redirect_to(@family) }
        format.xml  { render :xml => @family, :status => :created, :location => @family }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @family.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /families/1
  # PUT /families/1.xml
  def update
    @family = Family.find(params[:id])

    respond_to do |format|
      if @family.update_attributes(params[:family])
        flash[:notice] = "Family #{@family.business_name} was successfully updated."
        format.html { redirect_to(@family) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @family.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /families/1
  # DELETE /families/1.xml
  def destroy
#    @family = Family.find(params[:id])
#    @family.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(families_url) }
#      format.xml  { head :ok }
#    end
  end
end
