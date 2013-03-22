def insert_figaro_config_into_secret_token
  comment "# Edit secret token initializer file to reference"
  comment "# ENV value set in Figaro config"
  insert_into_file 'config/initializers/secret_token.rb',
                   before: /#{app_name.camelize}/ do <<-RUBY
if Rails.env.production? && ENV['SECRET_TOKEN'].blank?
  raise 'SECRET_TOKEN environment variable must be set!'
end

RUBY
  end
  insert_into_file 'config/initializers/secret_token.rb', after: /token =/ do
    "\n  ENV['SECRET_TOKEN'] ||"
  end
end

def clean_up_generated_simple_form_initializer
modern_hash_syntax 'config/initializers/simple_form.rb'
gsub_file 'config/initializers/simple_form.rb',
          /development\?\nend\n/
          "development\?\nend"
end