require 'spec_helper_lite'
require './lib/minions/minion'
require './lib/minions/supervisor'

class NoSetupMinion < Minions::Minion
  def perform
  end
end

class NoArgMinion < Minions::Minion
  def setup
  end

  def perform
  end

  def teardown
  end
end

class OneArgMinion < Minions::Minion
  def setup(a)
  end

  def perform(a)
  end
end

class TwoArgMinion < Minions::Minion
  def setup(a, b)
  end

  def perform(a, b)
  end
end

describe Minions::Minion do
  context 'when creating a new minion' do
    it 'will raise an exception if the minion class does not implement perform' do
      expect { subject.receive(nil) }.to raise_error('Minions must implement perform')
    end
  end

  context 'when receiving a message' do
    subject { NoArgMinion.new }

    it 'will automatically call the setup method' do
      expect(subject).to receive(:setup)

      subject.receive({})
    end

    it 'will not call setup if not defined' do
      expect { subject.receive(nil) }.not_to raise_error
    end

    it 'will automatically call the perform method' do
      expect(subject).to receive(:perform)

      subject.receive({})
    end

    it 'will automatically call the teardown method' do
      expect(subject).to receive(:teardown)

      subject.receive({})
    end

    it 'will not call teardown if not defined' do
      expect { subject.receive(nil) }.not_to raise_error
    end

    it 'will call setup with one argument if thats how its defined' do
      params = {message: 5}
      minion = OneArgMinion.new(params)
      expect(minion).to receive(:setup).with(5)

      minion.receive(params)
    end

    it 'will call setup with two arguments if thats how its defined' do
      params = {message: [5, 8]}
      minion = TwoArgMinion.new(params)

      expect(minion).to receive(:setup).with(5, 8)

      minion.receive(params)
    end
  end

  it 'will assign a new, empty mailbox to a new worker' do
    expect(subject.mailbox.size).to eql 0
  end

  context 'when replacing a minion' do
    let(:mailbox) { Minions::Mailbox.new }
    let(:message) {{ mode: :restore,
                    message: 'Stop sucking',
                    mailbox_id: mailbox.id }}
    subject { OneArgMinion.new(message) }
    it 'will restore the mailbox of a replacement worker' do
      expect(subject.mailbox.id).to eql mailbox.id
    end
  end
end
