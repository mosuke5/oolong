require 'active_record'
require 'yaml'
require 'mysql2'

config = YAML.load_file( '../db/database.yml' )

ActiveRecord::Base.establish_connection(config["db"]["development"])

class Measurement_data2 < ActiveRecord::Base
    #table nameを指定
    self.table_name = 'measurement_data2'
end
