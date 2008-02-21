class MonthlyDetailsController < ApplicationController
  before_filter :get_project_and_task
  
  # GET /monthly_details
  # GET /monthly_details.xml
  def index
    @monthly_details = MonthlyDetail.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @monthly_details }
    end
  end

  # GET /monthly_details/1
  # GET /monthly_details/1.xml
  def show
    @monthly_detail = MonthlyDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @monthly_detail }
    end
  end

  # GET /monthly_details/new
  # GET /monthly_details/new.xml
  def new
    @monthly_detail = MonthlyDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @monthly_detail }
    end
  end

  # GET /monthly_details/1/edit
  def edit
    @monthly_detail = MonthlyDetail.find(params[:id])
  end

  # POST /monthly_details
  # POST /monthly_details.xml
  def create
    @monthly_detail = MonthlyDetail.new(params[:monthly_detail])

    respond_to do |format|
      if @monthly_detail.save
        flash[:notice] = 'MonthlyDetail was successfully created.'
        format.html { redirect_to(@monthly_detail) }
        format.xml  { render :xml => @monthly_detail, :status => :created, :location => @monthly_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @monthly_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /monthly_details/1
  # PUT /monthly_details/1.xml
  def update
    @monthly_detail = MonthlyDetail.find(params[:id])

    respond_to do |format|
      if @monthly_detail.update_attributes(params[:monthly_detail])
        flash[:notice] = 'MonthlyDetail was successfully updated.'
        format.html { redirect_to(@monthly_detail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @monthly_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /monthly_details/1
  # DELETE /monthly_details/1.xml
  def destroy
    @monthly_detail = MonthlyDetail.find(params[:id])
    @monthly_detail.destroy

    respond_to do |format|
      format.html { redirect_to(monthly_details_url) }
      format.xml  { head :ok }
    end
  end
  
  def get_project_and_task
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:task_id])
  end
end