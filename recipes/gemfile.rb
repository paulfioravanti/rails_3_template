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