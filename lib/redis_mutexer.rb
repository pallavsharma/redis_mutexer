require "redis_mutexer/version"
require "redis"

module RedisMutexer

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

  # lockable locks the obj with user
  def lockable(obj, time)
    Logger.new(STDOUT)
    RedisMutexer.config.redis.setex("#{obj.class.name + ":" + obj.id.to_s}", time, self.id)
  end

  # check if the obj is locked with other user
  def locked?(obj)
    Logger.new(STDOUT)
    (RedisMutexer.config.redis.get("#{obj.class.name + ":" + obj.id.to_s}").to_i == self.id) ? true : false
  end
  
  # unlock obj if required
  def unlock(obj)
    Logger.new(STDOUT)
    RedisMutexer.config.redis.del("#{obj.class.name + ":" + obj.id.to_s}")
  end

  # check and lock obj with user
  # using redis multi
  def lock(obj, time)
    redis.multi do
      lockable(obj, time) unless locked?(obj)
    end
  end

  module_function :configure
end
