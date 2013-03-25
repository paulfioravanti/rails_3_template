def create_secure_database_config
  comment "# Remove default sqlite config and replace with secure postgresql"
  remove_file 'config/database.yml'
  copy_from_repo 'config/database.yml'
end

def create_databases
  rake 'db:create', env: 'development'
  rake 'db:create', env: 'test'
end