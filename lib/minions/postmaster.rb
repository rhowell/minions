require 'singleton'
# Postmaster is a non-persistent, non-distributed manager for
# mailboxes, designed to manage mailboxes outside of of the
# minion lifecycle.  It will have to be completely rewritten
# or thrown away when we move to the distributed functionality.
module Minions

  class PostMaster
    include Singleton

    def register(mailbox)
      @mailboxes[mailbox.id] = mailbox
    end

    def self.register(mailbox)
      self.instance.register(mailbox)
    end

    def self.mailbox(id)
      self.instance.mailbox(id)
    end

    def mailbox(id)
      @mailboxes[id]
    end

    private
    def initialize
      @mailboxes = {}
    end
  end
end
