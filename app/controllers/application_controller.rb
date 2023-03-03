class ApplicationController < ActionController::Base
  # 以下を追記
  include SessionsHelper

  private def current_user
    if session[:user_id]
      User.find_by(id:session[:user_id])
    end
  end
end
