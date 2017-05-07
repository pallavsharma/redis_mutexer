require "redis_mutexer/version"
require "redis"

module RedisMutexer

  def redis
    redis ||= Redis.new(host: 'localhost',
                        port: '6379',
                        db:   'redis_mutexer'
                       )
  end

  # lockable locks the obj with user
  def lockable(obj, time)
    redis.setex("#{obj.class.name + ":" + obj.id.to_s}", time, self.id)
  end

  # check if the obj is locked with other user
  def locked?(obj)
    (redis.get("#{obj.class.name + ":" + obj.id.to_s}").to_i == self.id) ? true : false
  end

  # unlock obj if required
  def unlock(obj)
    redis.del("#{obj.class.name + ":" + obj.id.to_s}")
  end

  # check and lock obj with user
  def lock(obj, time)
    return if locked?(obj)
    lockable(obj, time)
  end
end
