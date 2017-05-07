require "spec_helper"

describe RedisMutexer do

  it "has a version number" do
    expect(RedisMutexer::VERSION).not_to be nil
  end

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
