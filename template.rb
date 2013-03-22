Dir[File.dirname(__FILE__) + '/recipes/*.rb'].each { |file| require file }
## Before using this generator:
# rvm use 2.0.0
# rvm gemset use rails3213 (or whatever other preferred gemset)

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