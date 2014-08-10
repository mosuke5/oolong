require 'active_record'
require 'yaml'
require 'mysql2'

config = YAML.load_file( './config/database.yml' )

ActiveRecord::Base.establish_connection(config["db"]["development"])

class Hoge < ActiveRecord::Base
end
