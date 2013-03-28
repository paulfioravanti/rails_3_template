include ApplicationHelper

def fill_in_fields(user, new_name = nil, new_email = nil)
  scope = 'activerecord.attributes.user'
  fill_in t(:name, scope: scope),     with: new_name || user.name
  fill_in t(:email, scope: scope),    with: new_email || user.email
  # fill_in t(:password, scope: scope), with: user.password
  # fill_in t(:password_confirmation, scope: scope), with: user.password
  # Get elements by IDs
  fill_in 'user_password', with: user.password
  fill_in 'user_password_confirmation', with: user.password
end

def sign_in_through_ui(user)
  scope = 'sessions.new'
  fill_in t(:email, scope: scope),    with: user.email
  fill_in t(:password, scope: scope), with: user.password
  click_button t(:signin, scope: scope)
end

def sign_in_request(user)
  post session_path(email: user.email, password: user.password)
  cookies[:authentication_token] = user.authentication_token
end

def invalid_email_addresses
  %w[user@foo,com user_at_foo.org example.user@foo.
    foo@bar_baz.com foo@bar+baz.com]
end

def valid_email_addresses
  %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
end

def t(string, options = {})
  I18n.t(string, options)
end

RSpec::Matchers::define :have_alert_message do |type, message|
  match do |page|
    page.has_selector?("div.alert.alert-#{type}", text: message)
  end
end