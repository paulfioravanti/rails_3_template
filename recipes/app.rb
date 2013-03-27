def clean_up_routes
  remove_comments 'config/routes.rb'
  comment "# Remove generated route spaces"
  gsub_file 'config/routes.rb', /\'pages\#home\'\n+/, "'pages#home'\n"

  comment "# Remove extraneous generated route entry"
  gsub_file 'config/routes.rb',
            /^\s+get \"pages\/home\"\n+/, ''
end

def replace_application_helper
  comment "# Replace application_helper.rb with custom version"
  remove_file 'app/helpers/application_helper.rb'
  copy_from_repo 'app/helpers/application_helper.rb'
end

def create_resources_for_pages
  comment "# Create pages controller"
  copy_from_repo 'app/controllers/pages_controller.rb'
  comment "# Create home view"
  copy_from_repo 'app/views/pages/home.html.haml'
  comment "# Create generic page partial"
  copy_from_repo 'app/views/pages/_page.html.haml'
  comment "# Create home Markdown file"
  copy_from_repo 'config/locales/pages/home/home.en.md', erb: true
end

def clean_up_generated_app_content
  comment "# Remove public/index.html to enable root path"
  remove_file 'public/index.html'

  comment "# Remove test directory as not needed for RSpec"
  run 'rm -rf test/'
end