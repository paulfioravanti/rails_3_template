## Before using this generator:
# rvm use 2.0.0
# rvm gemset use rails3213 (or whatever other preferred gemset)

### Utility Methods ###########################################################

def colorize(text, color_code); "\e[#{color_code}m#{text}\e[0m"; end
def yellow(text); colorize(text, 33); end
def cyan(text); colorize(text, 36); end
def comment(text); say yellow(text); end

def heading(text)
  say "\n"
  say cyan "#######################################"
  say cyan "## #{text}"
  say cyan "#######################################"
  say "\n"
end

def secret_token
  token = StringIO.new
  IO.popen("rake secret") do |pipe|
    pipe.each do |line|
      token.print line.chomp
    end
  end
  token.string
end

def copy_from_repo(filename, erb: false)
  begin
    repo = 'https://raw.github.com/paulfioravanti/rails_template/master/files/'
    get "#{repo}#{filename}", filename
    template "#{Dir.pwd}/#{filename}", force: true if erb
  rescue OpenURI::HTTPError
    say "Unable to obtain #{filename} from the repo #{repo}"
  end
end

def change_double_to_single_quotes(filename)
  comment "# Change double to single quotes"
  gsub_file filename, /"/, "'"
end

def remove_comments(filename)
  comment "# Remove generated comments"
  gsub_file filename, /^\s{2}?\#.*\n/, ''
end

def remove_blank_lines(filename)
  comment "# Remove excess blank lines"
  gsub_file filename, /(?m)^(?<!\w\n$)\n(?!\w+)/, ''
end

def modern_hash_syntax(filename)
  comment "# Change hashes to modern syntax"
  gsub_file filename, /([^\w^:]):([\w\d_]+)\s*=>/, '\1\2:'
end

### Gems methods ##############################################################

def universal_gems
  comment "# View gems"
  gem 'haml-rails', '~> 0.4.0'
  gem 'will_paginate', '~> 3.0.4'
  gem 'bootstrap-will_paginate', '~> 0.0.9'
  gem 'simple_form', '~> 2.0.4'
  gem 'rails-timeago', '~> 2.2.0'
  # Markdown
  gem 'rdiscount', '~> 2.0.7.1'

  say "\n"
  comment "# Controller gems"
  gem 'strong_parameters', '~> 0.2.0'

  say "\n"
  comment "# i18n"
  # i18n strings for default Rails
  gem 'rails-i18n', '~> 0.7.3'
  # i18n for database content
  gem 'globalize3', '~> 0.3.0'
  gem 'localeapp', '~> 0.6.9'
  # For accessing i18n in js files
  gem 'i18n-js', '~> 2.1.2'

  say "\n"
  comment "# App & 3rd party secret key configuration"
  gem 'figaro', '~> 0.6.3'
end

def database_gem
  say "\n"
  comment "# Set preferred database to postgres"
  gsub_file 'Gemfile', /gem 'sqlite3'\n/, "gem 'pg', '~> 0.14.1'\n"
end

def development_only_gems
  say "\n"
  comment "# :development group only gems"
  gem_group :development do
    # Annotate model/route files with their properties
    gem 'annotate', '~> 2.5.0'
    ### For html/erb to haml parsing; required by HAML
    gem 'html2haml', '~> 1.0.1'
    gem 'hpricot', '~> 0.8.6'
    gem 'ruby_parser', '~> 3.1.2'
    # Security checking
    gem 'brakeman', '~> 1.9.4'
    ### Code quality gems
    gem 'reek', '~> 1.3.1'
    gem 'rails_best_practices', '~> 1.13.4'
    # Query optimization monitoring
    gem 'bullet', '~> 4.4.0'
    # Debugging information
    gem 'rails-footnotes', '~> 3.7.9'
    # Better error pages
    gem 'better_errors', '~> 0.7.2'
    gem 'binding_of_caller', '~> 0.7.1'
    # Gem for RailsPanel Chrome extension
    gem 'meta_request', '~> 0.2.2'
  end
end

def development_and_test_gems
  say "\n"
  comment "# :development and :test group gems"
  gem_group :development, :test do
    gem 'rspec-rails', '~> 2.13.0'
    # for autotesting with rspec
    gem 'guard-rspec', '~> 2.5.1'
    # Prettier RSpec output
    gem 'fuubar', '~> 1.1.0'
    # Use factories instead of ActiveRecord objects
    gem 'factory_girl_rails', '~> 4.2.1'
    # gem 'debugger', '1.3.3' ## Broken in Ruby 2.0.0
    # For deploying from Travis worker and generating
    # Figaro-based Heroku env variables
    gem 'heroku', '~> 2.35.0'
  end
end

def test_only_gems
  say "\n"
  comment "# :test group only gems"
  gem_group :test do
    # For fake example users with “realistic” names/emails
    gem 'faker', '~> 1.1.2'
    # Helps in testing by simulating how a real user would use app
    gem 'capybara', '~> 2.0.2'
    gem 'shoulda-matchers', '~> 1.5.2'
    # gem 'shoulda-matchers', '1.5.0' # currently has Mocha dependency issues
    # Cucumber for user stories and db cleaner utility below
    gem 'cucumber-rails', '~> 1.3.1', require: false
    gem 'database_cleaner', '~> 0.9.1'
    # speed up test server
    gem 'spork', '~> 0.9.2'
    # guard/spork integration
    gem 'guard-spork', '~> 1.5.0'
    # Helps in debugging tests by being able to launch browser
    gem 'launchy', '~> 2.2.0'
    ### Code coverage reports
    gem 'simplecov', '~> 0.7.1', require: false
    gem 'coveralls', '~> 0.6.2', require: false
    # Performance testing  ## Broken in Ruby 2.0.0
    # gem 'rack-perftools_profiler', require: 'rack/perftools_profiler'
    # Test other databases on Travis CI if needed
    # gem 'mysql2', '0.3.11'
    # gem 'sqlite3', '1.3.7'
    ### Mac-dependent gems
    gem 'rb-fsevent', '~> 0.9.3', require: false
    # Growl notifications
    gem 'growl', '~> 1.0.3'
  end
end

def assets_gems
  say "\n"
  comment "# Add gems under already generated :assets group"
  insert_into_file 'Gemfile', after: "group :assets do\n" do <<-RUBY
    gem 'bootstrap-sass', '~> 2.3.1.0'
    gem 'font-awesome-sass-rails', '~> 3.0.2.2'
  RUBY
  end
end

### Gemfile methods ###########################################################

def add_explicit_ruby_version
  comment "# Define explicit Ruby version for Heroku"
  insert_into_file 'Gemfile', after: "source 'https://rubygems.org'\n" do
    "ruby '#{RUBY_VERSION}'\n"
  end
end

def change_rubygems_source
  comment "# Change source to http version due to"
  comment "# unreliablilty of https version"
  gsub_file 'Gemfile', "source 'https://rubygems.org'\n",
                       "source 'http://rubygems.org'\n"
end

def insert_line_breaks_before_groups
  comment "# Insert blank lines before :groups"
  insert_into_file 'Gemfile', "\n", before: "group :assets do", force: true
  insert_into_file 'Gemfile', "\n", before: "group :development do", force: true
end

### Environment methods #######################################################

def split_out_locale_files
  comment "# Add support for split out locale files under config/locales/*"
  application "config.i18n.load_path += "\
              "Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]"
end

def remove_test_unit_from_railties
  comment "# Replace rails/all with individual railties"
  comment "# except test::unit (using RSpec)"
  gsub_file 'config/application.rb', "require 'rails/all'" do <<-RUBY
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_resource/railtie'
require 'sprockets/railtie'
RUBY
  end
end

def set_lazy_asset_precompilation
  comment "# Precompile assets lazily in production.  Works with Heroku if you have"
  comment "# $ heroku labs:enable user-env-compile -a myapp"
  comment_lines 'config/application.rb',
    /Bundler.require\(\*Rails\.groups\(\:assets \=\> \%w\(development test\)\)\)/
  uncomment_lines 'config/application.rb',
    /Bundler\.require\(\:default, \:assets, Rails\.env\)/
end

def suppress_helper_and_view_spec_generation
  comment "# Don't generate helper or view specs"
  insert_into_file 'config/application.rb', after: "Rails::Application\n" do <<-RUBY
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
      g.fixture_replacement :factory_girl_rails
    end
  RUBY
  end
end

def no_asset_debug
  comment "# Change assets.debug to false due to GET assets error on locale change"
  gsub_file 'config/environments/development.rb',
            'config.assets.debug = true',
            'config.assets.debug = false'
end

### Initializer methods #######################################################

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

### Javascript methods ########################################################

def require_custom_javascript
  comment "# Require JS for JQuery, rails-timeago, i18n-js, bootstrap"
  insert_into_file 'app/assets/javascripts/application.js',
                   after: /require jquery_ujs\n/ do <<-JAVASCRIPT
//= require jquery-ui
//= require rails-timeago
//= require i18n
//= require i18n/translations
//= require bootstrap
JAVASCRIPT
  end
end

### CSS methods ###############################################################

def customize_application_css
  comment "# Change application.css into scss document"
  run "mv app/assets/stylesheets/application.css "\
      "app/assets/stylesheets/application.css.scss"

  comment "# Substitute out require_tree in favour of manual ordered requiring"
  comment "# of CSS files in application.css.scss"
  gsub_file 'app/assets/stylesheets/application.css.scss',
            /\s\*\= require_tree \.\n/, ''
  comment "# Add reference to Bootstrap and overrides CSS file in application.css.scss"
  append_to_file 'app/assets/stylesheets/application.css.scss',
                 "@import \"bootstrap_and_overrides.css.scss\";"
end

def create_custom_css
  comment "# Create Bootstrap and overrides CSS file"
  copy_from_repo 'app/assets/stylesheets/bootstrap_and_overrides.css.scss'

  comment "# Create CSS file scss variables and mixins"
  copy_from_repo 'app/assets/stylesheets/variables_and_mixins.css.scss'

  comment "# Create CSS file for header"
  copy_from_repo 'app/assets/stylesheets/header.css.scss'

  comment "# Create CSS file for footer"
  copy_from_repo 'app/assets/stylesheets/footer.css.scss'
end

### Views methods #############################################################

def customize_application_view
  comment "# Convert generated application view file to HAML"
  run "html2haml app/views/layouts/application.html.erb > "\
      "app/views/layouts/application.html.haml"
  remove_file 'app/views/layouts/application.html.erb'

  modern_hash_syntax 'app/views/layouts/application.html.haml'

  comment "# Change html header to html5"
  gsub_file 'app/views/layouts/application.html.haml',
            /\!\!\!/, '!!! 5'

  comment "# Yield title to helper method"
  gsub_file 'app/views/layouts/application.html.haml',
            /\%title\s#{app_name.camelize}/, '%title= full_title(yield(:title))'

  comment "# Add controller/action properties to body tag for any custom CSS"
  insert_into_file 'app/views/layouts/application.html.haml',
                   "{ class: \"\#\{controller_name\}\-controller "\
                   "\#\{action_name\}\-action\" }",
                   after: /\%body/

  comment "# Insert IE handling code for HTML5 and code for i18n_js, timeago gems"
  comment "# into application.html.haml"
  insert_into_file 'app/views/layouts/application.html.haml',
                   after: /csrf_meta_tags\n/ do <<-RUBY
    = timeago_script_tag
    = render 'layouts/shim'
    = render 'layouts/i18n_js'
RUBY
  end

  comment "# Insert call to header, messages partials under yield"
  insert_into_file 'app/views/layouts/application.html.haml',
                    before: /^\s+\=\syield/ do <<-RUBY
    = render 'layouts/header'
    .container
      = render 'layouts/messages'
RUBY
  end

  comment "# Insert call to footer partial under yield"
  insert_into_file 'app/views/layouts/application.html.haml',
                   "      = render 'layouts/footer'",
                   after: /^\s+\=\syield\n/

  comment "# Move yield call to within bootstrap .container class"
  gsub_file 'app/views/layouts/application.html.haml',
            /^\s+\=\syield\n/, "      = yield\n"
end

### Spec methods ##############################################################

def remove_cucumber_env_white_space
  comment "# Clean up excess generated white space in cucumber that prevents git commit"
  gsub_file 'features/support/env.rb', /\:truncation\n\n/, ":truncation"
  gsub_file 'features/support/env.rb', /from how\s\n/, "from how\n"
  gsub_file 'features/support/env.rb', /page will\s\n/, "page will\n"
end

def customize_guard_file
  comment "# Edit generated default file so Guard doesn’t run all tests"
  comment "# after a failing test passes."
  gsub_file 'Guardfile',
            /guard 'rspec' do/,
            "guard 'rspec', version: 2, all_after_pass: false, cli: '--drb' do"
  modern_hash_syntax 'Guardfile'
end

###############################################################################
######################### Application Template ################################
###############################################################################

heading "Define gems" #########################################################

universal_gems
database_gem
development_only_gems
development_and_test_gems
test_only_gems
assets_gems

heading "Edit Gemfile" ########################################################

change_double_to_single_quotes 'Gemfile'
remove_comments 'Gemfile'
remove_blank_lines 'Gemfile'
modern_hash_syntax 'Gemfile'
add_explicit_ruby_version
change_rubygems_source
insert_line_breaks_before_groups

heading "Configure RVM" #######################################################

comment "# Set up RVM Bundler integration to eliminate"
comment "# the use of `bundle exec` in commands:"
run 'rvm get head && rvm reload'
chmod "#{ENV['rvm_path']}/hooks/after_cd_bundler", "+x"

heading "Edit Environment files" ##############################################

comment "## Application"
say "\n"

split_out_locale_files
remove_test_unit_from_railties
set_lazy_asset_precompilation
suppress_helper_and_view_spec_generation

say "\n"
comment "## Development"
say "\n"

no_asset_debug

heading "Config/create pg database" ###########################################

comment "# Remove default sqlite config and replace with postgresql"
remove_file 'config/database.yml'
copy_from_repo 'config/database.yml'

heading "Figaro config" #######################################################

comment "# Get a new secret token to put in Figaro application config;"
comment "# will be used in production."
copy_from_repo 'config/application.yml', erb: true

comment "# Create example application config to check into source control"
copy_from_repo 'config/application.example.yml'

rake 'db:create:all'

comment "# Setup binstubs are to eliminate the use of exec in commands"
run 'bundle install --binstubs=./bundler_stubs'

heading "Configure Initializers" ##############################################

insert_figaro_config_into_secret_token

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

comment "# Create simple_form initializer file,"
comment "# change its hashes to modern syntax, and remove extraneous blank lines"
generate 'simple_form:install --bootstrap'
clean_up_generated_simple_form_initializer

comment "# Create strong_parameters initializer file"
copy_from_repo 'config/initializers/strong_parameters.rb'

comment "# Create timago initializer file"
copy_from_repo 'config/initializers/timeago.rb'

heading "Configure locale structure" ##########################################

comment "# Create activerecord locale file"
copy_from_repo 'config/locales/activerecord/activerecord.en.yml'

comment "# Create flash locale file"
copy_from_repo 'config/locales/flash/flash.en.yml'

comment "# Create helpers locale file"
copy_from_repo 'config/locales/helpers/helpers.en.yml'

comment "# Create layouts locale file"
copy_from_repo 'config/locales/layouts/layouts.en.yml', erb: true

comment "# Create shared locale file"
copy_from_repo 'config/locales/shared/shared.en.yml'

comment "# Create faker locale file under vendor/"
copy_from_repo 'config/locales/vendor/faker.en.yml'

comment "# Replace generated simple_form locale file for one under vendor/"
copy_from_repo 'config/locales/vendor/simple_form.en.yml'
remove_file 'config/locales/simple_form.en.yml'

comment "# Create will_paginate locale file under vendor/"
copy_from_repo 'config/locales/vendor/will_paginate.en.yml'

heading "Create/overrride Bootstrap JS/CSS" ###################################

require_custom_javascript
customize_application_css
create_custom_css

heading "Customize generated views" #############################################

customize_application_view

comment "# Create HTML5 shim"
copy_from_repo 'app/views/layouts/_shim.html.haml'

comment "# Pass rails locale into javascript files"
copy_from_repo 'app/views/layouts/_i18n_js.html.haml'

comment "# Create i18n-js.yml so that i18n-js compile issues don't occur"
rake 'i18n:js:setup'

comment "# Create basic messages partial"
copy_from_repo 'app/views/layouts/_messages.html.haml'

comment "# Create basic header partial"
copy_from_repo 'app/views/layouts/_header.html.haml', erb: true

comment "# Create basic footer partial"
copy_from_repo 'app/views/layouts/_footer.html.haml'

heading "Generate base routes" ################################################

route "root to: 'pages#home'"

comment "# Remove generated route comments and spaces"
remove_comments 'config/routes.rb'
gsub_file 'config/routes.rb', /\'pages\#home\'\n+/, "'pages#home'\n"

heading "Generate base controller/action" #####################################

generate "controller", "pages home"

comment "# Remove extraneous generated route entry"
gsub_file 'config/routes.rb',
          /^\s+get \"pages\/home\"\n+/, ''

heading "Create basic helper" #################################################

comment "# Replace application_helper.rb with custom version"
remove_file 'app/helpers/application_helper.rb'
copy_from_repo 'app/helpers/application_helper.rb'

comment "# Remove public/index.html to enable root path"
remove_file 'public/index.html'

heading "Setup Testing Frameworks" ############################################

comment "# Remove test directory as not needed for RSpec"
run 'rm -rf test/'

comment "# Configure app for testing (RSpec, Cucumber with Spork and Guard)"
generate 'rspec:install'
generate 'cucumber:install'
run 'spork --bootstrap'
run 'spork cucumber --bootstrap'

remove_cucumber_env_white_space

comment "# Configure RSpec output to use Fuubar"
append_to_file '.rspec', "--format Fuubar\n--drb"

comment "# Replace generated spec_helper.rb with custom version"
remove_file 'spec/spec_helper.rb'
copy_from_repo 'spec/spec_helper.rb', erb: true

heading "Configure Guard" #####################################################

run 'guard init rspec'
run 'guard init spork'

customize_guard_file

heading "Create initial basic specs" ##########################################

comment "# Create home page routing spec"
copy_from_repo 'spec/routing/routing_spec.rb'

comment "# Create spec for \#full_title method"
copy_from_repo 'spec/helpers/application_helper_spec.rb'

comment "# Add i18n.t helper and include ApplicationHelper to utilities.rb"
copy_from_repo 'spec/support/utilities.rb'

heading "Git-related config" ##################################################

comment "# Append custom content to .gitignore"
remove_file '.gitignore'
copy_from_repo '.gitignore'
uncomment_lines '.gitignore', /\/config\/application.yml/

git :init
comment "# Stop commit of extraneous white space in git repo"
run 'mv .git/hooks/pre-commit.sample .git/hooks/pre-commit'

heading "Install gems, run tests, commit" #####################################

run 'bundle install --binstubs=./bundler_stubs'
run 'rspec spec/'
git add: "."
git commit: %Q{ -m 'Initial commit' }