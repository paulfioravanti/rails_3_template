## Before using this generator:
# $ rvm use 2.0.0

# def repo_root; "#{Dir.pwd}/../rails_template"; end
def repo_root
  'https://raw.github.com/paulfioravanti/rails_template/master'
end

apply "#{repo_root}/utilities.rb"

heading "Define gems" ##########################################################
apply recipe("gems")

universal_gems
database_gem
development_only_gems
development_and_test_gems
test_only_gems
assets_gems

heading "Edit Gemfile" #########################################################
apply recipe("gemfile")

change_double_to_single_quotes 'Gemfile'
remove_comments 'Gemfile'
remove_blank_lines 'Gemfile'
modern_hash_syntax 'Gemfile'
add_explicit_ruby_version
change_rubygems_source
insert_line_breaks_before_groups

heading "Configure RVM" ########################################################
apply recipe("rvm")

update_rvm
create_rvm_bundler_integration
set_ruby_version_and_app_gemset_in_rvm_env

heading "Edit Environment files" ###############################################
apply recipe("environment")

sub_heading "Application"

split_out_locale_files
remove_test_unit_from_railties
set_lazy_asset_precompilation
suppress_helper_and_view_spec_generation

sub_heading "Development"

no_asset_debug

heading "Config/create pg database" ############################################
apply recipe("database")

create_secure_database_config

heading "Figaro config" ########################################################
apply recipe("figaro")

create_secure_app_config
create_example_app_config

# Secret config that database config references is
# now available so database can be generated
rake 'db:create', env: 'development'
rake 'db:create', env: 'test'

heading "Configure Initializers" ###############################################
apply recipe("initializers")

create_basic_initializers_for_installed_gems
insert_figaro_config_into_secret_token
simple_form_initializer
i18n_js_initializer

heading "Configure locale structure" ###########################################
apply recipe("locales")

create_rails_locales
create_app_locales
create_vendor_locales

heading "Create/overrride Bootstrap JS/CSS" ####################################

apply recipe("javascript")
require_custom_javascript

apply recipe("css")
customize_application_css
create_custom_css

heading "Customize generated views" ############################################
apply recipe("views")

customize_application_view
create_partials_for_layout

heading "Generate initial routes" ##############################################

apply recipe("app")
route "root to: 'pages#home'"

heading "Generate base controller/action" ######################################

create_resources_for_pages
clean_up_routes

heading "Create basic helper" ##################################################

comment "# Replace application_helper.rb with custom version"
remove_file 'app/helpers/application_helper.rb'
copy_from_repo 'app/helpers/application_helper.rb'

heading "App Clean Up" #########################################################

clean_up_generated_app_content

heading "Setup Testing Frameworks" #############################################
apply recipe("spec")

bootstrap_test_frameworks
configure_rspec
remove_cucumber_env_white_space
customize_guard_file

heading "Create initial basic specs" ###########################################

create_initial_specs

heading "Git-related config" ###################################################
apply recipe("git")

create_git_ignore
git :init
prevent_whitespaced_commits

heading "Run tests, commit" ####################################################

run 'rspec spec/'
git add: "."
git commit: %Q{ -m 'Initial commit' }