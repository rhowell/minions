require 'minions/mailbox'

module Minions
  class Minion
    attr_reader :mailbox

    # Never call this directly, instead use the setup & perform methods
    # The system will use initialize when restoring actors
    def initialize(params={})
      local_init(params)

      if params[:mode] && params[:mode] == :restore
        @mailbox = Minions::PostMaster.mailbox(params[:mailbox_id])
      else
        @mailbox = Minions::Mailbox.new
      end
    end
    private
    def local_init(params)
      if !self.respond_to? :perform
        fail 'Minions must implement perform'
      end

      if self.respond_to? :setup
        if self.method(:setup).parameters.size > 0
          self.send(:setup, *params[:message])
        else
          self.send(:setup)
        end
      end

      if self.method(:perform).parameters.size > 0
        self.send(:perform, *params[:message])
      else
        self.send(:perform)
      end
    end

  end
end
