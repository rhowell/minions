require 'securerandom'

class Minions::Mailbox
  def initialize
    @messages = []
  end

  def receive(message)
    @messages << {uuid: SecureRandom.uuid, message: message, time_stamp: Time.now}
  end

  def read
    @messages.first
  end

  def delivered(msg)
    @messages.delete_if { |m| m[:uuid] == msg[:uuid] }
  end

  def size
    @messages.size
  end
end
