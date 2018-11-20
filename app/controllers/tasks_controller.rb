class TasksController < ApplicationController
  before_action :require_user_logged_in
  # before_filter :authenticate_user!
  before_action :my_tasks
  
  
  def index
    @tasks = current_user.tasks.all.page(params[:page])
  end
  
  def show
    set_task
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'タスクが正常に登録されました'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'タスクは登録されませんでした'
      render 'toppages/index'
    end
  end
  
  def edit
    set_task
  end
  
  def update
    set_task
    
    if @task.update(task_params)
      flash[:success] = 'タスクが正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクは更新されませんでした'
      render :new
    end
  end
  
  def destroy
    set_task
    @task.destroy
    
    flash[:success] = 'タスクは正常に削除されました'
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def set_task
    @task = current_user.tasks.find(params[:id])
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
  def my_tasks
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      flash[:warning] = '他ユーザのタスクは閲覧できません。'
      redirect_back(fallback_location: root_url)
    end
  end

end
