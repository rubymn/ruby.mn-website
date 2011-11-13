class ProjectsController < ApplicationController
  before_filter :login_required, :except => :index
  before_filter :find_project,   :only => [:edit, :update, :destroy]

  def index
    @projects = Project.includes(:user).order(:title)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    @project.user = current_user

    if @project.save
      redirect_to projects_path, :notice => 'Project was successfully added.'
    else
      render :action => :new
    end
  end

  def edit
    if @project
      if @project.user != current_user
        session[:uid] = nil
        redirect_to root_path
      end
    else
      render :action => :new
    end
  end

  def update
    if @project.user == current_user
      if @project.update_attributes(params[:project])
        redirect_to projects_path, :notice => 'Project was successfully updated.'
      else
        render :action => :edit
      end
    else
      session[:uid] = nil
      redirect_to root_path
    end
  end

  def destroy
    if @project.user == current_user
      @project.destroy
      redirect_to projects_path, :notice => 'Project was successfully removed.'
    else
      session[:uid] = nil;
      redirect_to root_path
    end
  end


  protected

    def find_project
      @project = Project.find params[:id]
    end

end
