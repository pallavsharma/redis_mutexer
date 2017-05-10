require "redis_mutexer/version"
require "redis"
#require "pry"

module RedisMutexer
  class Configuration
    attr_accessor :redis, :host, :port, :db, :time, :logger

    def initialize
      @host = 'localhost'    #host
      @port = 6379           #port
      @db = 'redis_mutexer'  #database namespace
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
                db:   config.db
               )
    @config.logger = config.logger
    @config.logger.debug "Config called"
    @config.logger ||= Logger.new(STDOUT)
  end

  # alias redis
  def redis
    RedisMutexer.config.redis
  end

  # alias logger
  def logger
    RedisMutexer.config.logger
  end

  # set redis key
  def key(obj)
    "#{self.class.name}:#{obj.class.name}:#{obj.id}"
  end

  # lockable locks the obj with user
  def lock(obj, time = RedisMutexer.config.time)
    logger
    locked = RedisMutexer.config.redis.setnx(key(obj), self.id)
    if locked
      return RedisMutexer.config.redis.expire(key(obj), time)
    end
    locked
  end

  # this will check if the obj is locked with any user.
  def locked?(obj)
    RedisMutexer.config.redis.exists(key(obj))
  end

  # to check if the user is the owner of the lock.
  def owner?(obj)
    (self.id == RedisMutexer.config.redis.get(key(obj)).to_i)
  end

  # find time remaining to expire a lock in seconds.
  def unlocking_in(obj)
    RedisMutexer.config.redis.ttl(key(obj))
  end

  # unlock obj if required
  def unlock(obj)
    logger
    if locked?(obj)
      RedisMutexer.config.redis.del(key(obj))
    end
  end

  module_function :configure
end
