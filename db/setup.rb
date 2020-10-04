require 'yaml'
require 'active_record'
require_relative 'links_migration.rb'
require_relative '../utils/file_parser'
require 'pry'

def create_database config
  config_clone  = config.dup
  config_clone["database"] = "postgres"
  establish_conn(config_clone)
  puts "Creating Database : #{config["database"]}--"
  db_connection.create_database(config["database"])
end

def db_connection
  ActiveRecord::Base.connection
end

def is_connection_established? 
  db_connection rescue return false
  true
end

def establish_conn db_config
  ActiveRecord::Base.establish_connection(db_config)
end

begin
  db_config = FileParser.parse('db/database.yml')
  table_name = "links"

  establish_conn db_config
  unless  is_connection_established? 
    create_database(db_config)
    establish_conn db_config
  end

  db_connection.drop_table(table_name)  if db_connection.table_exists?(table_name)
  CreateLinkTable.migrate(:up)
  puts  "#{table_name} table has created"
end
