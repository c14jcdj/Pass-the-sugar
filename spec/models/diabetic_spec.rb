require 'spec_helper'
describe Diabetic do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should allow_value("test@test.com").for :email}
    it { should_not allow_value("qlskr.com","teae",12).for :email}
    it { should allow_value(Date.today - (rand(15)+1) ).for :birthday }
  end

  describe "associations" do
    it { should belong_to :doctor }
    it { should belong_to :account }
    it { should have_many :records }
  end

  it 'should have an age method that returns the age' do
    age = rand(50)+1
    params = {
      name: CoolFaker::Character.name,
      email: Faker::Internet.email,
      birthday: {
                    year: Date.today.year - age,
                    month: Date.today.month,
                    day: Date.today.day
                  }
    }

    expect(Diabetic.new(params).age).to eq(age - 1)
  end
end
