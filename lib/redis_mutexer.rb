require "redis_mutexer/version"
require "redis"
require 'active_support/concern'

module RedisMutexer
  extend ActiveSupport::Concern

  class Configuration
    attr_accessor :redis, :host, :port, :db, :time, :logger

    def initialize
      @host = 'localhost'    #host
      @port = 6379           #port
      @db = '1'  #database namespace
      @time = 60             #seconds
    end
  end

  class << self
    attr_accessor :config
  end

  def configure
    @config ||= Configuration.new
    yield(config) if block_given? 

    # Create a redis connection if not provided with
    @config.redis ||=
      Redis.new(host: config.host,
                port: config.port,
                db:   config.db,
                time: config.time
               )
    @config.logger = config.logger
    @config.logger.debug "Config called"

    @config.logger ||= Logger.new(STDOUT)
  end

  def lock(obj, time)
    Logger.new(STDOUT)
    RedisMutexer.config.redis.setex("#{obj.class.name + ":" + obj.id.to_s}", time, self.id)
  end
  def locked?(obj)
    (RedisMutexer.config.redis.get("#{obj.class.name + ":" + obj.id.to_s}").to_i == self.id) ? true : false
  end
  def unlock(obj)
    RedisMutexer.config.redis.del("#{obj.class.name + ":" + obj.id.to_s}")
  end

  module_function :configure
end
