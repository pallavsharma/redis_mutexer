require "spec_helper"

describe RedisMutexer do
  describe RedisMutexer::Configuration do
    subject { RedisMutexer::Configuration.new }

    attribute_list = [
      :redis, :host, :port, :db,
      :time, :logger
    ]

    attribute_list.each do |attr|
      it { should respond_to attr }
    end
  end

  it "has a version number" do
    expect(RedisMutexer::VERSION).not_to be nil
  end

  subject {
    RedisMutexer.tap do |redis_mutexer| 
      redis_mutexer.configure  do |config|
        config.host = "localhost"
        config.port = "6379"
        config.db = "1"
        config.time = 60            # Number of api call during timeout
        config.logger = Logger.new(STDOUT)
      end
    end
  }

  it { should respond_to :configure }

  describe "when provided a block" do
    let (:user) { User.create!(name: "pallav sharma")}
    let (:topic) { Topic.create!(title: "this is test title")}

    it "does something useful" do
      user.lock(topic, 60)
      user.locked?(topic)
      user.unlock(topic)
    end
  end

end
