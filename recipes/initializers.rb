def create_basic_initializers_for_installed_gems
  comment "# Create Better Errors initializer file"
  comment "# with support for Sublime Text 2"
  copy_from_repo 'config/initializers/better_errors.rb'

  comment "# Create Bullet initializer file"
  copy_from_repo 'config/initializers/bullet.rb'

  comment "# Create i18n initializer file"
  copy_from_repo 'config/initializers/i18n.rb'

  comment "# Create Rails Footnotes initializer file"
  comment "# with monkey patch for HAML views,"
  comment "# and support for Sublime Text 2"
  copy_from_repo 'config/initializers/rails_footnotes.rb'

  comment "# Create strong_parameters initializer file"
  copy_from_repo 'config/initializers/strong_parameters.rb'

  comment "# Create timeago initializer file"
  copy_from_repo 'config/initializers/timeago.rb'
end

def insert_figaro_config_into_secret_token
  comment "# Edit secret token initializer file to reference"
  comment "# ENV value set in Figaro config"
  insert_into_file 'config/initializers/secret_token.rb',
                   before: %r(#{app_name.camelize}) do <<-RUBY
if Rails.env.production? && ENV['SECRET_TOKEN'].blank?
  raise 'SECRET_TOKEN environment variable must be set!'
end

RUBY
  end
  insert_into_file 'config/initializers/secret_token.rb', after: %r(token =) do
    "\n  ENV['SECRET_TOKEN'] ||"
  end
end

def simple_form_initializer
  comment "# Create simple_form initializer file,"
  comment "# change its hashes to modern syntax, and remove extraneous blank lines"
  generate 'simple_form:install --bootstrap'
  modern_hash_syntax 'config/initializers/simple_form.rb'
  gsub_file 'config/initializers/simple_form.rb',
            %r(development\?\nend\n)
            "development\?\nend"
end

def i18n_js_initializer
  comment "# Create i18n-js.yml so that i18n-js compile issues don't occur"
  rake 'i18n:js:setup'
end