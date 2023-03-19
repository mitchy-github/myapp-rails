class ApplicationController < ActionController::Base
  # 以下を追記
  include SessionsHelper
end
