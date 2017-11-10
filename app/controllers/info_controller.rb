class InfoController < ApplicationController

  before_filter :set_info, except: [:index, :new, :create]
  before_filter :auth, except: [:index, :show]

  def index
    @info = Info.order(:title).page(params[:page])
  end

  def show
    @prev = Info.where(["title < ?", @info.title]).order(:title).last  || Info.order(:title).last
    @next = Info.where(["title > ?", @info.title]).order(:title).first || Info.order(:title).first
  end

  def new
    @info = Info.new
  end

  def edit
  end

  def create
    @info = Info.new(info_params)
    if @info.save
      redirect_to @info, notice: 'The info page has been created!'
    else
      flash[:alert] = "An error occured while creating the info page."
      render action: "new"
    end
  end

  def update
    @info.attributes = info_params()
    if @info.save
      redirect_to @info, notice: 'The info page has been updated!'
    else
      flash[:alert] = "An error occured while updating the info page."
      render action: "edit"
    end
  end

  def destroy
    if @info.destroy
      flash[:notice] = "The info page has been deleted!"
    else
      flash[:alert] = "An error occured while deleting the info page."
    end
    redirect_to info_index_path
  end


  private

  def info_params(add = [])
    a = [:title, :content]
    a += add
    params.require(:info).permit(a)
  end

  def set_info
    @info = Info.find(params[:id])
  end

  def auth
    unless mod?
      flash[:alert] = "You are not allowed to edit info pages!"
      redirect_to @info ? @info : info_index_path
    end
  end
end
