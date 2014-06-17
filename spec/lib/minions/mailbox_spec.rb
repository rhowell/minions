require 'spec_helper_lite'
require './lib/minions/mailbox'
require './lib/minions/postmaster'
require 'timecop'

describe Minions::Mailbox do
  context 'When receiving a message' do
    before(:each) { subject.receive('Hello World') }

    it 'can recall message sent to it' do
      expect(subject.read[:message]).to eql 'Hello World'
    end

    it 'shall assign a unique ID to every mesasge' do
      subject.receive('Hello Again')

      expect(subject.read[:uuid]).to_not be_nil
    end

    it 'shall retain messages until marked as delivered' do
      expect(subject.size).to eql 1

      msg = subject.read

      expect(subject.size).to eql 1

      subject.delivered(msg)

      expect(subject.size).to eql 0
    end
  end

  it 'shall deliver messages in the order they are received' do
    subject.receive('msg 1')
    subject.receive('msg 2')

    msg = subject.read
    expect(msg[:message]).to eql 'msg 1'
    subject.delivered(msg)

    msg = subject.read
    expect(msg[:message]).to eql 'msg 2'
    subject.delivered(msg)
  end

  it 'shall add a timestamp when a message is received' do
    new_time = Time.local(2008, 9, 1, 12, 0, 0)
    Timecop.freeze(new_time)
    subject.receive('Old School!')

    Timecop.return

    expect(subject.read[:time_stamp]).to eql new_time
  end

  it 'shall assign a unique id to each mailbox' do
    expect(Minions::Mailbox.new.id).to_not eql Minions::Mailbox.new.id
  end

  it 'will automatically register itself with the postmaster' do
    expect(Minions::PostMaster.mailbox(subject.id)).not_to be_nil
  end
end
