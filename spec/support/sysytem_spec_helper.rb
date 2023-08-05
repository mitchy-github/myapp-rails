# frozen_string_literal: true

module SystemSpecHelper
  def log_in_as(user)
    visit login_path
    fill_in "session[email]",    with: user.email
    fill_in "session[password]", with: user.password
    click_button "ログイン"
  end
end
  # def wait_for_turbo(timeout = nil)
  #   if has_css?('.turbo-progress-bar', visible: true, wait: (0.25).seconds)
  #     has_no_css?('.turbo-progress-bar', wait: timeout.presence || 5.seconds)
  #   end
  # end

