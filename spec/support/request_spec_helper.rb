module RequestSpecHelper
  def log_in_as(user, email: user.email, password: user.password)
    post login_path, params: { session: { email: user.email, password: user.password } }
  end
end
