def customize_application_view
  comment "# Convert generated application view file to HAML"
  run "html2haml app/views/layouts/application.html.erb > "\
      "app/views/layouts/application.html.haml"
  remove_file 'app/views/layouts/application.html.erb'

  modern_hash_syntax 'app/views/layouts/application.html.haml'

  comment "# Change html header to html5"
  gsub_file 'app/views/layouts/application.html.haml',
            %r(\!\!\!), '!!! 5'

  comment "# Yield title to helper method"
  gsub_file 'app/views/layouts/application.html.haml',
            %r(\%title\s#{app_name.camelize}), '%title= full_title(yield(:title))'

  comment "# Add controller/action properties to body tag for any custom CSS"
  insert_into_file 'app/views/layouts/application.html.haml',
                   "{ class: \"\#\{controller_name\}\-controller "\
                   "\#\{action_name\}\-action\" }",
                   after: %r(\%body)

  comment "# Insert IE handling code for HTML5 and code for i18n_js, timeago gems"
  comment "# into application.html.haml"
  insert_into_file 'app/views/layouts/application.html.haml',
                   after: %r(csrf_meta_tags\n) do <<-RUBY
    = timeago_script_tag
    = render 'layouts/shim'
    = render 'layouts/i18n_js'
RUBY
  end

  comment "# Insert call to header, messages partials under yield"
  insert_into_file 'app/views/layouts/application.html.haml',
                    before: %r(^\s+\=\syield) do <<-RUBY
    = render 'layouts/header'
    .container
      = render 'layouts/messages'
RUBY
  end

  comment "# Insert call to footer partial under yield"
  insert_into_file 'app/views/layouts/application.html.haml',
                   "      = render 'layouts/footer'",
                   after: %r(^\s+\=\syield\n)

  comment "# Move yield call to within bootstrap .container class"
  gsub_file 'app/views/layouts/application.html.haml',
            %r(^\s+\=\syield\n), "      = yield\n"
end

def create_partials_for_layout
  comment "# Create HTML5 shim"
  copy_from_repo 'app/views/layouts/_shim.html.haml'

  comment "# Pass rails locale into javascript files"
  copy_from_repo 'app/views/layouts/_i18n_js.html.haml'

  comment "# Create basic messages partial"
  copy_from_repo 'app/views/layouts/_messages.html.haml'

  comment "# Create basic header partial"
  copy_from_repo 'app/views/layouts/_header.html.haml', erb: true

  comment "# Create basic footer partial"
  copy_from_repo 'app/views/layouts/_footer.html.haml'
end