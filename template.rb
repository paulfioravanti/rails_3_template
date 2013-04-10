## Before using this generator:
# $ rvm use 2.0.0

local_location = "rails_template/template.rb"
remote_location = "https://raw.github.com/paulfioravanti/"\
                  "rails_template/master/template.rb"

# Determine which template to use based on parameter given in generator
# rails new my_app -m <template>
template_path = ARGV[2]
if template_path == remote_location
  define_singleton_method :repo_root do
    'https://raw.github.com/paulfioravanti/rails_template/master'
  end
elsif template_path == local_location
  define_singleton_method :repo_root do
    "#{Dir.pwd}/../rails_template"
  end
end

apply "#{repo_root}/utilities.rb"

heading "Define Gems" ##########################################################
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
set_rvm_ruby_version
# set_rvm_gemset

heading "Edit Environment Files" ###############################################
apply recipe("environment")

sub_heading "Application"

split_out_locale_files
remove_test_unit_from_railties
set_lazy_asset_precompilation
suppress_helper_and_view_spec_generation

sub_heading "Development"

no_asset_debug

heading "Figaro Config" ########################################################
apply recipe("figaro")

create_secure_app_config
create_example_app_config

heading "Config/create Postgres Database" ######################################
apply recipe("database")

create_secure_database_config
destroy_any_previous_databases
create_databases

heading "Configure Initializers" ###############################################
apply recipe("initializers")

create_basic_initializers_for_installed_gems
insert_figaro_config_into_secret_token
simple_form_initializer
i18n_js_initializer

heading "Configure Locale Structure" ###########################################
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

heading "Create Base Models" ###################################################
apply recipe("models")

generate_model_migrations
replace_migration_content
migrate_databases
create_model_classes

seed_databases

heading "Customize Generated Views" ############################################
apply recipe("views")

customize_application_view
create_partials_for_layout

heading "Generate Initial Routes" ##############################################
apply recipe("app")

replace_routes

heading "Generate App Resources" ###############################################

create_shared_resources
create_page_resources
create_session_resources
create_user_resources

heading "App Clean Up" #########################################################

clean_up_generated_app_content
annotate_app

heading "Setup Testing Frameworks" #############################################
apply recipe("spec")

bootstrap_test_frameworks
configure_rspec
remove_cucumber_env_white_space
customize_guard_file

heading "Create initial basic specs" ###########################################

create_initial_specs
create_initial_factories

heading "Git-related config" ###################################################
apply recipe("git")

create_git_ignore_file
create_git_repo
prevent_whitespaced_commits

heading "Run tests, commit" ####################################################

run_tests
add_and_commit_to_repo