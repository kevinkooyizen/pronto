module SessionsHelper
  def sign_in(input)
    session[:user_id] = input.id
  end

  def sign_out
    session[:user_id] = nil
  end


  def authenticate(email, password)
    if user = find_by_normalized_email(email)
      if password.present? && user.authenticate(password)
        user
      end
    end
  end

  def find_by_normalized_email(email)
    User.find_by(email: normalize_email(email)) 
  end

  def normalize_email(email)
    email.to_s.downcase.gsub(/\s+/, "")
  end
end
