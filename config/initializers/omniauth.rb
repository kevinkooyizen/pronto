Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
    scope: 'email, user_birthday, public_profile, user_location', info_fields: 'email, birthday, name, first_name, last_name, gender, location', display: 'popup'
end