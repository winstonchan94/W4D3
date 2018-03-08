class CatRentalRequestsController < ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :require_ownership, only: [:approve, :deny]

  def require_ownership
    unless current_cat && current_cat.owner == current_user
      flash[:errors] = ['You do not own this cat']
      redirect_to root_url
    end
  end

  def require_login
    unless logged_in?
      flash[:errors] = ['You must be logged in to request a cat']
      redirect_to root_url
    end
  end

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    @rental_request.requester = current_user
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  def new
    @rental_request = CatRentalRequest.new
  end

  private

  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :end_date, :start_date, :status)
  end
end
