require 'spec_helper_lite'
require './lib/minions/minion'

class NoSetupMinion < Minions::Minion
  def perform
  end
end

class NoArgMinion < Minions::Minion
  def setup
  end

  def perform
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
      expect { Minions::Minion.new }.to raise_error('Minions must implement perform')
    end

    it 'will automatically call the setup method' do
      minion = NoArgMinion.new
      expect(minion).to receive(:setup)

      minion.send(:local_init, {})
    end

    it 'will not call setup if not defined' do
      expect { NoSetupMinion.new }.not_to raise_error
    end

    it 'will call setup with one argument if thats how its defined' do
      params = {message: 5}
      minion = OneArgMinion.new(params)
      expect(minion).to receive(:setup).with(5)

      minion.send(:local_init, params)
    end

    it 'will call setup with two arguments if thats how its defined' do
      params = {message: [5, 8]}
      minion = TwoArgMinion.new(params)

      expect(minion).to receive(:setup).with(5, 8)

      minion.send(:local_init, params)
    end
  end

  it 'will assign a new, empty mailbox to a new worker' do
    minion = NoArgMinion.new
    expect(minion.mailbox.size).to eql 0
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
