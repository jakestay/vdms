require 'spec_helper'

describe Meeting do
  before(:each) do
    @meeting = Factory.build(:meeting)
  end

  describe 'Attributes' do
    it 'has a Time (time)' do
      @meeting.should respond_to(:time)
      @meeting.should respond_to(:time=)
    end

    it 'has a Room (room)' do
      @meeting.should respond_to(:room)
      @meeting.should respond_to(:room=)
    end

    it 'has an attribute name to accessor map' do
      Meeting::ATTRIBUTES['Time'].should == :time
      Meeting::ATTRIBUTES['Room'].should == :room
    end
  end

  describe 'Associations' do
    it 'belongs to a faculty (faculty)' do
      @meeting.should belong_to(:faculty)
    end

    it 'has and belongs to many admits' do
      @meeting.should have_and_belong_to_many(:admits)
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @meeting.should be_valid
    end

    it 'is not valid with an invalid time' do
      ['', 'foobar'].each do |invalid_time|
        @meeting.time = invalid_time
        @meeting.should_not be_valid
      end
    end

    it 'is not valid without a room' do
      @meeting.room = ''
      @meeting.should_not be_valid
    end
  end
end
