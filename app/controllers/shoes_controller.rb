class ShoesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shoe, only: %i[show destroy]

  def index; end

  def show; end

  def new
    @shoe = current_user.shoes.build
  end

  def create
    @shoe = current_user.shoes.create(shoes_params)
    if @shoe.save
      redirect_to shoes_path, notice: "Shoe Created"
    else
      render "new"
    end
  end

  def destroy
    @shoe.destroy
    redirect_to shoes_path, notice: "Shoe deleted!"
  end

  private

  def shoes_params
    params
      .require(:shoe)
      .permit(:name, :retired, :allowed_distance_in_miles)
  end

  def set_shoe
    @shoe = Shoe.find(params[:id])
  end

end
