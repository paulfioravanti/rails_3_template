def create_secure_database_config
  comment "# Remove default sqlite config and replace with secure postgresql"
  remove_file 'config/database.yml'
  copy_from_repo 'config/database.yml'
end

def destroy_any_previous_databases
  rake 'db:drop', env: 'development'
  rake 'db:drop', env: 'test'
end

def create_databases
  rake 'db:create', env: 'development'
  rake 'db:create', env: 'test'
end

def migrate_databases
  comment "# Migrate database"
  rake 'db:migrate', env: 'development'
  rake 'db:migrate', env: 'test'
end