require 'minions/minion'

module Minions
  class Supervisor
    def initialize
      @minions = []
    end

    def add(minion)
      if minion.is_a? Minions::Minion
				minion.supervisor(self)
        @minions << minion
      else
        fail "Expected minioin, received #{minion.class}"
      end
    end

    def receive(message)
      route(message).receive(message)
    end

		def report_failure(e)
		end

    protected
    def route(message)
      @minions.sample
    end
  end
end
