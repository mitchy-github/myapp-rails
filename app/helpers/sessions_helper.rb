module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if session[:user_id]
      #@current_user = @current_user || User.find_by(id: session[:user_id])と同じ意味
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

   # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    current_user.present?
  end

  def require_login
    redirect_to login_path unless logged_in?
  end

   # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  private
  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      redirect_to login_url, alert: "ログインか新規登録をしてください"
    end
  end
end
