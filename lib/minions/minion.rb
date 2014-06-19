require 'minions/mailbox'
require 'minions/supervisor'

module Minions
  class Minion
    attr_reader :mailbox

    # Never call this directly, instead use the setup & perform methods
    # The system will use initialize when restoring actors
    def initialize(params={})
      if params[:mode] && params[:mode] == :restore
        @mailbox = Minions::PostMaster.mailbox(params[:mailbox_id])
      else
        @mailbox = Minions::Mailbox.new
      end
    end

    def receive(params)
      if !self.respond_to? :perform
        fail 'Minions must implement perform'
      end

			execute(params)
    end

		def supervisor(supervisor)
			@supervisor = supervisor
		end

		private
		def execute(params)
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

      if self.respond_to? :teardown
        self.send(:teardown)
      end
    rescue => e
      @supervisor && @supervisor.report_failure(e)
		end
  end
end
