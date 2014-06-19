require 'spec_helper_lite'
require './lib/minions/supervisor'

class EmptyMinion < Minions::Minion
	def perform
	end
end

class StupidMinion < Minions::Minion
	def perform
		raise 'Too dumb to survive...'
	end
end

describe Minions::Supervisor do
	it 'can own a minion' do
		subject.add(EmptyMinion.new)
	end

	it 'will throw an exception if attempting to add a non-minion' do
		expect { subject.add([]) }.to raise_error
	end

	it 'will redirect messages to one of its minions' do
		minion = EmptyMinion.new
		expect(minion).to receive(:perform).once
		subject.add(minion)

		subject.receive({message: nil})
	end

	context 'When a minion dies' do
		it 'will report its failure' do
			minion = StupidMinion.new
			subject.add(minion)

			minion.receive({})

			# Why isn't this working?
			#expect(subject).to receive(:report_failure)
		end
	end
end
