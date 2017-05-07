require "bundler/setup"
require "redis_mutexer"

require 'rubygems'
require 'active_record'
require 'rspec'
require 'pry'
require "generator_spec"


PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')).freeze
$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')
Dir[File.join(PROJECT_ROOT, 'spec/support/**/*.rb')].each { |file| require(file) }

RSpec.configure do |c|
  c.before(:all) { setup_db }
  c.after(:all)  { teardown_db }
  c.before(:suite) do
    Time.zone = 'Pacific Time (US & Canada)'
  end
end

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :users do |t|
      t.string   :name
      t.timestamps
    end
    create_table :topics do |t|
      t.string   :title
      t.timestamps
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class User < ActiveRecord::Base
  include RedisMutexer
end

class Topic < ActiveRecord::Base
end
