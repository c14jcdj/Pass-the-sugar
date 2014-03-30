require 'spec_helper'

describe Record do

  context "associations" do
    it {should belong_to :diabetic}
  end

  context "validations" do

    it { should validate_presence_of(:taken_at) }
    it { should_not allow_value('derp').for :weight }
    it { should_not allow_value('derp').for :glucose }
    it { should allow_value('100').for :glucose }
    it { should_not allow_value('One Hundred').for :glucose }
    it { should allow_value('175').for :weight }
    it { should_not allow_value('One Seventy Five').for :weight }
    it { should_not allow_value(Time.now()+(60*60*24)).for :taken_at }  #one day from now
    it { should allow_value(Time.now()-(60*60)).for :taken_at }  #one hour *ago*
  end

end

