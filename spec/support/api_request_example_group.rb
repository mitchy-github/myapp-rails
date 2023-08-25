# spec/support/api_request_example_group.rb

# frozen_string_literal: true
module ApiRequestExampleGroup
  extend ActiveSupport::Concern

  included do
    around do |ex|
      ActionController::Base.allow_forgery_protection = true
      ex.call
    ensure
      ActionController::Base.allow_forgery_protection = false
    end
  end
end
