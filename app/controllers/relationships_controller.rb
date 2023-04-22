class RelationshipsController < ApplicationController
  
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer, status: :unprocessable_entity
  end
  
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer, status: :see_other
  end
end
