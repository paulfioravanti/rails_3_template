include ApplicationHelper

def fill_in_fields(user, new_name = nil, new_email = nil, remember_me: "true")
  ar_scope = 'activerecord.attributes.user'
  user_scope = 'users.fields'
  fill_in t(:name, scope: ar_scope),     with: new_name || user.name
  fill_in t(:email, scope: ar_scope),    with: new_email || user.email
  # Use custom labels for Password, Password confirmation
  # due to Capybara ambiguities error: a string can't be a substring of another
  # element otherwise it's considered ambiguous
  fill_in t(:password, scope: user_scope), with: user.password
  fill_in t(:password_confirmation, scope: user_scope), with: user.password
  if remember_me == "true"
    check t(:remember_me, scope: user_scope)
  else
    uncheck t(:remember_me, scope: user_scope)
  end
end

def sign_in_through_ui(user, remember_me: "true")
  scope = 'sessions.new'
  fill_in t(:email, scope: scope),    with: user.email
  fill_in t(:password, scope: scope), with: user.password
  if remember_me == "true"
    check t(:remember_me, scope: scope)
  else
    uncheck t(:remember_me, scope: scope)
  end
  click_button t(:signin, scope: scope)
end

def sign_in_request(user, remember_me: "true")
  post session_path(
    session: {
      email: user.email,
      password: user.password,
      remember_me: remember_me
    }
  )
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