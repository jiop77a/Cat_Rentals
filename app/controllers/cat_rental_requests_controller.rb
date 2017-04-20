class CatRentalRequestsController < ApplicationController
  before_filter :ensure_correct_owner, only:[:approve, :deny]
  before_filter :ensure_correct_requester, only:[:create]

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    @rental_request.user_id = @requester.id
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
    params.require(:cat_rental_request)
      .permit(:cat_id, :end_date, :start_date, :status)
  end

  def ensure_correct_owner
    @cat = @current_user.cats.where(id: params[:id])
    if @cat.empty?
      flash[:errors] << "You are not the owner of this cat"
      redirect_to cats_url
    end
  end

  def ensure_correct_requester
    @requester = @current_user
  end
end
