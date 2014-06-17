require 'minions/postmaster'
require 'securerandom'

class Minions::Mailbox
  # Mailboxes require an ID for when an actor dies,
  # a reborn actor can pickup and process it's mail
  attr_reader :id

  def initialize
    @messages = []
    @id = SecureRandom.uuid

    Minions::PostMaster.register(self)
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
