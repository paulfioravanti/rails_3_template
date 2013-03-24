def clean_up_routes
  comment "# Remove generated route comments and spaces"
  remove_comments 'config/routes.rb'
  gsub_file 'config/routes.rb', /\'pages\#home\'\n+/, "'pages#home'\n"

  comment "# Remove extraneous generated route entry"
  gsub_file 'config/routes.rb',
            /^\s+get \"pages\/home\"\n+/, ''
end

def clean_up_generated_app_content
  comment "# Remove public/index.html to enable root path"
  remove_file 'public/index.html'

  comment "# Remove test directory as not needed for RSpec"
  run 'rm -rf test/'
end