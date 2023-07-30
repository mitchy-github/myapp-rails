class ApplicationController < ActionController::Base
  # 以下を追記
  include SessionsHelper
  # protect_from_forgery with: :exception
end
