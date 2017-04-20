class CatsController < ApplicationController
  before_filter :ensure_correct_owner, only:[:edit, :update]
  def index

    @cats = Cat.all
    current_user
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
    @cat.user_id = @current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    render :edit
  end

  def update
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat)
      .permit(:age, :birth_date, :color, :description, :name, :sex)
  end

  def ensure_correct_owner
    @cat = @current_user.cats.find_by(id: params[:id])
    if @cat.nil?
      flash[:errors] << "You are not the owner of this cat"
      redirect_to cats_url
    end
  end
end
