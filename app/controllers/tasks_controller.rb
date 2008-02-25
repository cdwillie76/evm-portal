class TasksController < ApplicationController
  before_filter :get_project
  
  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = @project.tasks.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = @project.tasks.find(params[:id])
    @monthly_details = @task.monthly_details

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = @project.tasks.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = @project.tasks.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = @project.tasks.new(params[:task])
    
    respond_to do |format|
      if @task.save
        flash[:notice] = "#{@task.name} was successfully created."
        format.html { redirect_to(project_path(@project)) }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = @project.tasks.find(params[:id])

    respond_to do |format|
      #if @task.update_attributes(params[:task])
      if @task.monthly_details.update(params[:monthly_detail].keys, params[:monthly_detail].values)
        flash[:notice] = "#{@task.name} was successfully updated."
        format.html { redirect_to(project_task_path(@project, @task)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = @project.tasks.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(project_path(@project)) }
      format.xml  { head :ok }
    end
  end
  
  # PUT /tasks/1/extend_end_date
  def extend_end_date
    @task = @project.tasks.find(params[:id])
    @task.extend_end_date

    respond_to do |format|
      flash[:notice] = "#{@task.name} was successfully extended by a month."
      format.html { redirect_to(project_task_path(@project, @task, :edit_plan => "")) }
      format.xml  { head :ok }
    end
  end
  
  # PUT /tasks/1/complete
  def complete
    @task = @project.tasks.find(params[:id])

    respond_to do |format|
      if @task.ready_to_be_completed?
        @task.complete_task
        flash[:notice] = "#{@task.name} is complete"
      else
        flash[:error] = "#{@task.name} cannot be completed at this time.  Please make the actual percent complete 100% before completing."
      end
      format.html { redirect_to(project_task_path(@project, @task)) }
      format.xml  { head :ok }
    end
  end

  protected
  
  def get_project
    @project = Project.find(params[:project_id])
  end
end