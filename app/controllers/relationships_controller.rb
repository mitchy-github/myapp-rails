class RelationshipsController < ApplicationController
  
  def create
    # binding.pry
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end
  
  def destroy
    # binding.pry
    current_user.unfollow(params[:user_id])
    redirect_to request.referer, status: :see_other
  end
end
