module SessionsHelper
  def current_user
    if @current_user.nil?
      remember_token = encrypt(cookies.signed[:remember_token])
      user_id = begin
                  Session.where('created_at > :time OR updated_at > :time', time: Time.now - 1.hour).find_by(remember_token: remember_token).user_id
                rescue
                  nil
                end
      @current_user = User.find(user_id) unless user_id.nil?
    end
    @current_user
  end

  def keep_session_alive
    unless cookies.signed[:remember_token].nil?
      s = Session.find_by(remember_token: encrypt(cookies.signed[:remember_token]))
      if s.nil?
        cookies.clear
      else
        # If someone is signed in make their cookie valid for another hour
        remember_token = cookies.signed[:remember_token]
        cookies.signed[:remember_token] = { value: remember_token, expires: 1.hour.from_now }
        # Also update the last time that they took an action
        s.updated_at = Time.now
        s.save
      end
    end
  end

  def log_in(user)
    remember_token = Session.new_remember_token
    cookies.signed[:remember_token] = { value: remember_token, expires: 1.hour.from_now }
    Session.create(user_id: user.id, remember_token: encrypt(remember_token), remote_ip: request.ip)
    @current_user = user
  end

  def log_out
    @current_user = nil
    s = Session.find_by(remember_token: encrypt(cookies.signed[:remember_token]))
    s.deactivate
    s.save

    cookies.delete(:remember_token)

    session.destroy
  end

  def logged_in?
    !current_user.nil?
  end
end
