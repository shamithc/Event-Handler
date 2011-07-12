class ManageController < ApplicationController
  require 'date'
  before_filter :require_session
  def require_session
    if session[:id]==nil
      redirect_to :controller=>"account",:action=>"login"
    end
  end
  def index
    #@emp=Employee.find(:first)
  end
  def home
    time=Time.now
    #year=time.year.to_s
    #month=time.month.to_s
    #day=time.day.to_s
    #a=year+"-"+month+"-"+day
   # date =  Date.strptime(a)
   # date = date + 32
      #render :text=>d2
   # @data1=EmployeeEvent.find_by_sql("SELECT * FROM employee_events WHERE event_date between #{date} and #{date+7}")
    # @data=EmployeeEvent.find_by_sql("select * from employee_events where (month=#{time.month} and day >=#{time.day}) or (month=#{time.month+1}) order by month")
    @data=EmployeeEvent.find_by_sql("SELECT *FROM employee_events
                                    WHERE DAY = DAY( now( ) )
                                    AND MONTH = MONTH( now( ) ) union all
                                    SELECT *
                                    FROM employee_events
                                    WHERE DAY = DAY( DATE_ADD( DATE( now( ) ) , INTERVAL 1 DAY ) )
                                    AND MONTH = MONTH(DATE_ADD( DATE( now( ) ) , INTERVAL 1 DAY ) )
                                    union all
                                    SELECT *
                                    FROM employee_events
                                    WHERE DAY = DAY( DATE_ADD( DATE( now( ) ) , INTERVAL 2 DAY ) )
                                    AND MONTH = MONTH(DATE_ADD( DATE( now( ) ) , INTERVAL 2 DAY ) )
                                    union all
                                    SELECT *
                                    FROM employee_events
                                    WHERE DAY = DAY( DATE_ADD( DATE( now( ) ) , INTERVAL 3 DAY ) )
                                    AND MONTH = MONTH(DATE_ADD( DATE( now( ) ) , INTERVAL 3 DAY ) )
                                    union all
                                    SELECT *
                                    FROM employee_events
                                    WHERE DAY = DAY( DATE_ADD( DATE( now( ) ) , INTERVAL 4 DAY ) )
                                    AND MONTH = MONTH(DATE_ADD( DATE( now( ) ) , INTERVAL 4 DAY ) )
                                    union all
                                    SELECT *
                                    FROM employee_events
                                    WHERE DAY = DAY( DATE_ADD( DATE( now( ) ) , INTERVAL 5 DAY ) )
                                    AND MONTH = MONTH(DATE_ADD( DATE( now( ) ) , INTERVAL 5 DAY ) )
                                    union all
                                    SELECT *
                                    FROM employee_events
                                    WHERE DAY = DAY( DATE_ADD( DATE( now( ) ) , INTERVAL 6 DAY ) )
                                    AND MONTH = MONTH(DATE_ADD( DATE( now( ) ) , INTERVAL 6 DAY ) )
                                    union all
                                    SELECT *
                                    FROM employee_events
                                    WHERE DAY = DAY( DATE_ADD( DATE( now( ) ) , INTERVAL 7 DAY ) )
                                    AND MONTH = MONTH(DATE_ADD( DATE( now( ) ) , INTERVAL 7 DAY ) )")
    #time=Time.now
    #@data=EmployeeEvent.where("id='7'")
    #render :text=>@data.id
  end
  def users
    @users=Employee.all(:order=>"fname")    
  end
  def add_user
    @employee=Employee.new(params[:employee])
    if @employee.save
      name=@employee.fname+@employee.lname
      @employee.update_attributes(:name=>name)
      redirect_to :action=>"users"
    else
      @users=Employee.all(:order=>"fname")
      render :action=>"users"
      #render :text=>"dsdfsdgsdfg"
    end
  end
  def delete_user
    id=params[:id]
    Employee.delete(id)
    EmployeeEvent.delete_all(:employee_id=>params[:id])
    redirect_to :action=>"users"
  end
  def event
    @events=Event.all
  end
  def view_event
    id=params[:id]
    @event=Event.find(id)
    @employee_event=EmployeeEvent.find(:all,:conditions=>["event_id=?",id])
    @count=EmployeeEvent.count(:conditions=>["event_id=?",id])
    render :partial=> "view_event"
    #render :text=>@event.event
  end
  def assign
    id=params[:id]
    @event=Event.find(id)
    #render :text=>@event.user_specific and return
    #@employers=Employee.all(:order=>"fname")
    render :partial=> "assign_event"
  end
  def assign_event
    key=params[:employee_event][:employee_id]
    #if key==''
    flash[:msg]="Not Assigned..   select aperson"
    #      redirect_to :action=>"view"
    #   else
    id=params[:id]
    #date=params[:eve]
    #render :text=>date
    @employee_event=EmployeeEvent.new(params[:employee_event])
    if @employee_event.save
      @date=EmployeeEvent.last
      date=@date.event_date
      @employee_event.update_attributes(:year=>date.year,:month=>date.month,:day=>date.day,:event_id=>id)
      redirect_to :action=>"event"
    else
      @events=Event.all
      render :action=>"event"
    end     
    #  end
  end
  def delete_event
    #id=params[:id]
    #render :text=>id
    EmployeeEvent.delete(params[:id])
    redirect_to :action=>"event"
  end
  def edit_date
    #id=params[:id]
    #render :text=>id
    #date=params[:employee_event][:event_date]
    #render :text=>date
    @employee_event=EmployeeEvent.find(params[:id])
    @employee_event.update_attributes(:event_date=>params[:employee_event][:event_date])
    @date=EmployeeEvent.find(params[:id])
    date=@date.event_date
    @employee_event.update_attributes(:year=>date.year,:day=>date.day,:month=>date.month)
    redirect_to :action=>"event"
  end
  def add_event
    #render :text=>params[:user_specific] and return
    @event=Event.new(params[:event])
    @event.save
    redirect_to :action=>"event"
  end
  def delete_event_all
    id=params[:id]
    #render :text=>id
    EmployeeEvent.delete_all(:event_id=>params[:id])
    Event.delete_all(:id=>params[:id])
    redirect_to :action=>"event"
  end
  def self.sendmail
      #email = @params["email"]
	    recipient ='cshamith@sparksupport.com'
	    subject = 'Testing'
	    message = 'Email Testing'
	    Emailer.deliver_contact(recipient, subject, message)
      		#return if request.xhr?
      	   #render :text => 'Message sent successfully'
  end
  def self.s1
      @event=Event.new
     @event.save
  end
  def edit_user
    @employee1=Employee.find(params[:id])
  end
  def update_user
   @employee=Employee.find(params[:id])
   if @employee.update_attributes(params[:employee1])
     redirect_to :action=>"users"
   else
     @employee1=Employee.find(params[:id])
     render :action=>"edit_user"
   end
  end
  def edit_mainevent
    @data=Event.find(params[:id])
  end
  def update_event
    @event=Event.find(params[:id])
    if @event.update_attributes(params[:data])
       redirect_to :action=>"event"
    else
      @data=Event.find(params[:id])
       render :action=>"edit_mainevent"
    end
  end
  def config
    @data=Configuration.all
  end
  def add_email
    @configuration=Configuration.new(params[:configuration])
   if  @configuration.save
     redirect_to :action=>"config"
   else
      @data=Configuration.all
      render :action=>"config"
   end
  end
  def delete_email
    Configuration.delete_all(:id=>params[:id])
    redirect_to :action=>"config"
  end
  def edit_email
    @data=Configuration.find(params[:id])
    render :partial=> "edit_email"
  end
  def update_email
    @configuration=Configuration.find(params[:id])
    if @configuration.update_attributes(params[:data])
       redirect_to :action=>"config"
    else
      @data=Configuration.all
      render :action=>"config"
    end
     
  end
end
