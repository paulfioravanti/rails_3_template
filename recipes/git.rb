def create_git_ignore
  comment "# Append custom content to .gitignore"
  remove_file '.gitignore'
  copy_from_repo '.gitignore'
end

def prevent_whitespaced_commits
  comment "# Stop commit of extraneous white space in git repo"
  run 'mv .git/hooks/pre-commit.sample .git/hooks/pre-commit'
end