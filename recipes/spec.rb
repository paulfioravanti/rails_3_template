def bootstrap_test_frameworks
  comment "# Configure app for testing (RSpec, Cucumber with Spork and Guard)"
  comment "# Bootstrap RSpec"
  generate 'rspec:install'
  comment "# Bootstrap Cucumber"
  generate 'cucumber:install'
  comment "# Bootstrap Spork"
  run 'spork --bootstrap'
  run 'spork cucumber --bootstrap'
  comment "# Bootstrap Guard with Rspec and Spork"
  run 'guard init rspec'
  run 'guard init spork'
end

def remove_cucumber_env_white_space
  comment "# Clean up excess generated white space in cucumber that prevents git commit"
  gsub_file 'features/support/env.rb', %r(\:truncation\n\n), ":truncation"
  gsub_file 'features/support/env.rb', %r(from how\s\n), "from how\n"
  gsub_file 'features/support/env.rb', %r(page will\s\n), "page will\n"
end

def configure_rspec
  comment "# Configure RSpec output to use Fuubar"
  append_to_file '.rspec', "--format Fuubar\n--drb"

  comment "# Replace generated spec_helper.rb with custom version"
  remove_file 'spec/spec_helper.rb'
  copy_from_repo 'spec/spec_helper.rb', erb: true
end

def customize_guard_file
  comment "# Edit generated default file so Guard doesn’t run all tests"
  comment "# after a failing test passes."
  gsub_file 'Guardfile',
            %r(guard 'rspec' do),
            "guard 'rspec', version: 2, all_after_pass: false, cli: '--drb' do"
  modernize_hash_syntax 'Guardfile'
end

def create_initial_specs
  comment "# Create home page routing spec"
  copy_from_repo 'spec/routing/routing_spec.rb'

  comment "# Create controller specs"
  copy_from_repo 'spec/controllers/application_controller_spec.rb'

  comment "# Create helper specs"
  copy_from_repo 'spec/helpers/application_helper_spec.rb'

  comment "# Create feature specs"
  copy_from_repo 'spec/features/pages_spec.rb', erb: true
  copy_from_repo 'spec/features/authentication_pages_spec.rb'
  copy_from_repo 'spec/features/user_pages_spec.rb'

  comment "# Create request specs"
  copy_from_repo 'spec/requests/authentication_requests_spec.rb'

  comment "# Create model specs"
  copy_from_repo 'spec/models/user_spec.rb'

  comment "# Create spec utilities"
  copy_from_repo 'spec/support/utilities.rb'
end

def create_initial_factories
  comment "# Create users factory"
  copy_from_repo 'spec/factories/users.rb'
end

def run_tests
  comment "# Run tests"
  run 'rspec spec/'
end