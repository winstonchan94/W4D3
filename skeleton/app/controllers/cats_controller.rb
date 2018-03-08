class CatsController < ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :require_ownership, only: [:edit, :update]

  def require_ownership
    @cat = Cat.find(params[:id])
    unless @cat && @cat.owner == current_user
      flash[:errors] = ['You do not own this cat']
      redirect_to root_url
    end
  end

  def require_login
    unless logged_in?
      flash[:errors] = ['You must be logged in to create cat']
      redirect_to root_url
    end
  end

  def index
    byebug
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.owner = current_user
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    # @cat assigned in require_ownership
    render :edit
  end

  def update
    # @cat assigned in require_ownership
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
