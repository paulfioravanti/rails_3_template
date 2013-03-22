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