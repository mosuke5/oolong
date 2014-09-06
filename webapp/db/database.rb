require 'active_record'
require 'yaml'
require 'mysql2'

config = YAML.load_file( './db/database.yml' )

ActiveRecord::Base.establish_connection(config["db"]["development"])
