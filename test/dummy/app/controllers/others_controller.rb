class OthersController < ApplicationController
  before_action :set_other, only: [:show, :edit, :update, :destroy]

  # GET /others
  def index
    @others = Other.all
  end

  # GET /others/1
  def show
  end

  # GET /others/new
  def new
    @other = Other.new
  end

  # GET /others/1/edit
  def edit
  end

  # POST /others
  def create
    @other = Other.new(other_params)

    if @other.save
      redirect_to @other, notice: 'Other was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /others/1
  def update
    if @other.update(other_params)
      redirect_to @other, notice: 'Other was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /others/1
  def destroy
    @other.destroy
    redirect_to others_url, notice: 'Other was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_other
      @other = Other.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def other_params
      params.require(:other).permit(:name, :permalink, :content)
    end
end
