class IdolsController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    @idol = @user.idols.create(idol_params)

    if @idol.save
      flash[:notice] = t(:idol_added)
      redirect_to @user
    else
      flash[:notice] = t(:idol_adding_failed)
      redirect_to @user
    end

  end

  def destroy
    @idol = Idol.find(params[:id])


    if @idol.destroy
      flash[:notice] = t(:idol_deleted)
      redirect_to @idol.user
    else
      flash[:notice] = t(:idol_deleting_failed)
      redirect_to @idol.user
    end
  end


  private

  def idol_params
    params.require(:idol).permit(:name, :page, :image)
  end

end
