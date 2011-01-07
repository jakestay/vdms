require 'spec_helper'

describe Faculty do
  before(:each) do
    @faculty = Factory.create(:faculty)
  end

  describe 'Attributes' do
    it 'has a CalNet ID (calnet_id)' do
      @faculty.should respond_to(:calnet_id)
      @faculty.should respond_to(:calnet_id=)
    end

    it 'has a First Name (first_name)' do
      @faculty.should respond_to(:first_name)
      @faculty.should respond_to(:first_name=)
    end

    it 'has a Last Name (last_name)' do
      @faculty.should respond_to(:last_name)
      @faculty.should respond_to(:last_name=)
    end

    it 'has an Email (email)' do
      @faculty.should respond_to(:email)
      @faculty.should respond_to(:email=)
    end

    it 'has an Area (area)' do
      @faculty.should respond_to(:area)
      @faculty.should respond_to(:area=)
    end

    it 'has a Division (division)' do
      @faculty.should respond_to(:division)
      @faculty.should respond_to(:division=)
    end

    it 'has a Schedule (schedule)' do
      @faculty.should respond_to(:schedule)
      @faculty.should respond_to(:schedule=)
    end

    it 'has a Default Room (default_room)' do
      @faculty.should respond_to(:default_room)
      @faculty.should respond_to(:default_room=)
    end

    it 'has a Max Admits Per Meeting preference (max_admits_per_meeting)' do
      @faculty.should respond_to(:max_admits_per_meeting)
      @faculty.should respond_to(:max_admits_per_meeting=)
    end

    it 'has a Max Additional Admits to meet with preference (max_additional_admits)' do
      @faculty.should respond_to(:max_additional_admits)
      @faculty.should respond_to(:max_additional_admits=)
    end

    it 'has an attribute name to accessor map' do
      Faculty::ATTRIBUTES['CalNet ID'].should == :calnet_id
      Faculty::ATTRIBUTES['First Name'].should == :first_name
      Faculty::ATTRIBUTES['Last Name'].should == :last_name
      Faculty::ATTRIBUTES['Email'].should == :email
      Faculty::ATTRIBUTES['Area'].should == :area
      Faculty::ATTRIBUTES['Division'].should == :division
      Faculty::ATTRIBUTES['Schedule'].should == :schedule
      Faculty::ATTRIBUTES['Default Room'].should == :default_room
      Faculty::ATTRIBUTES['Max Admits Per Meeting'].should == :max_admits_per_meeting
      Faculty::ATTRIBUTES['Max Additional Admits'].should == :max_additional_admits
    end
  end

  describe 'Associations' do
    it 'has many Admit Rankings (admit_rankings)' do
      @faculty.should have_many(:admit_rankings)
    end

    it 'has many Meetings (meetings)' do
      @faculty.should have_many(:meetings)
    end
  end

  context 'when building' do
    before(:each) do
      @faculty = Faculty.new
    end

    it 'has an empty Schedule by default' do
      @faculty.schedule.should be_empty
    end

    it 'has no default room (None)' do
      @faculty.default_room.should == 'None'
    end

    it 'has a default Max Admits Per Meeting preference of 1' do
      @faculty.max_admits_per_meeting.should == 1
    end

    it 'has a Max Additional Admits to meet with preference of No Limit' do
      @faculty.max_additional_admits.should == Float::MAX.to_i
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @faculty.should be_valid
    end

    it 'is not valid without a Calnet ID' do
      @faculty.calnet_id = ''
      @faculty.should_not be_valid
    end

    it 'is not valid without a First Name' do
      @faculty.first_name = ''
      @faculty.should_not be_valid
    end

    it 'is not valid without a Last Name' do
      @faculty.last_name = ''
      @faculty.should_not be_valid
    end

    it 'is not valid without an Email' do
      @faculty.email = ''
      @faculty.should_not be_valid
    end

    it 'is not valid with an invalid Email' do
      ['foobar', 'foo@bar', 'foo.com'].each do |invalid_email|
        @faculty.email = invalid_email
        @faculty.should_not be_valid
      end
    end

    it 'is not valid without an Area' do
      @faculty.area = ''
      @faculty.should_not be_valid
    end

    it 'is not valid without a Division' do
      @faculty.division = ''
      @faculty.should_not be_valid
    end

    it 'is not valid with an invalid Schedule'

    it 'is not valid without a Default Doom' do
      @faculty.default_room = ''
      @faculty.should_not be_valid
    end

    it 'is not valid with an invalid Max Admits Per Meeting preference' do
      ['', 0, -1, 5.5, 'foobar'].each do |invalid_preference|
        @faculty.max_admits_per_meeting = invalid_preference
        @faculty.should_not be_valid
      end
    end

    it 'is not valid with an invalid Max Additional Admits to meet with preference' do
      ['', -1, 5.5, 'foobar'].each do |invalid_preference|
        @faculty.max_additional_admits = invalid_preference
        @faculty.should_not be_valid
      end
    end
  end

  context 'when importing a CSV' do
    before(:each) do
      csv_text = <<-EOF.gsub(/^ {8}/, '')
        CalNet ID,First Name,Last Name,Email,Area,Division,Default Room,Max Admits Per Meeting,Max Additional Admits
        ID0,First0,Last0,email0@email.com,Area0,Division0,Room0,0,0
        ID1,First1,Last1,email1@email.com,Area1,Division1,Room1,1,1
        ID2,First2,Last2,email2@email.com,Area2,Division2,Room2,2,2
      EOF
      @csv = FasterCSV.parse(csv_text, :headers => :first_row)

      # Stub out the database and replace it with @faculty array
      @faculties = []
      new_faculties = Array.new(3) {Faculty.new}
      new_faculties.each do |faculty|
        faculty.stub(:save) {@faculties << faculty}
      end
      Faculty.stub(:new) do |*args|
        faculty = new_faculties.shift
        faculty.attributes = args[0]
        faculty
      end
    end

    it 'creates a Faculty per row' do
      Faculty.import_csv(@csv.to_s)
      @faculties.count.should == 3
    end

    it 'creates a Faculty with the attributes in each row' do
      Faculty.import_csv(@csv.to_s)
      @faculties.each_with_index do |faculty, i|
        faculty.calnet_id.should == "ID#{i}"
        faculty.first_name.should == "First#{i}"
        faculty.last_name.should == "Last#{i}"
        faculty.email.should == "email#{i}@email.com"
        faculty.area.should == "Area#{i}"
        faculty.division.should == "Division#{i}"
        faculty.default_room.should == "Room#{i}"
        faculty.max_admits_per_meeting.should == i
        faculty.max_additional_admits.should == i
      end
    end

    it 'creates a Faculty with the partial attributes in each row' do
      @csv.delete('First Name')
      @csv.delete('Last Name')
      Faculty.import_csv(@csv.to_s)
      @faculties.each_with_index do |faculty, i|
        faculty.calnet_id.should == "ID#{i}"
        faculty.email.should == "email#{i}@email.com"
        faculty.area.should == "Area#{i}"
        faculty.division.should == "Division#{i}"
        faculty.default_room.should == "Room#{i}"
        faculty.max_admits_per_meeting.should == i
        faculty.max_additional_admits.should == i
      end
    end

    it 'ignores extraneous attributes' do
      csv_text = <<-EOF.gsub(/^ {8}/, '')
        CalNet ID,Baz,First Name,Last Name,Email,Foo,Bar
        ID0,Baz0,First0,Last0,email0@email.com,Foo0,Bar0
        ID1,Baz1,First1,Last1,email1@email.com,Foo1,Bar1
        ID2,Baz2,First2,Last2,email2@email.com,Foo2,Bar2
      EOF
      Faculty.import_csv(csv_text)
      @faculties.count.should == 3
      @faculties.each_with_index do |faculty, i|
        faculty.calnet_id.should == "ID#{i}"
        faculty.first_name.should == "First#{i}"
        faculty.last_name.should == "Last#{i}"
        faculty.email.should == "email#{i}@email.com"
      end
    end

    it 'returns the collection of created Faculties' do
      Faculty.import_csv(@csv.to_s).should == @faculties
    end
  end
end
