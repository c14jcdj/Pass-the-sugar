require 'spec_helper'



describe Preference do

  context "validations" do
    it { should validate_numericality_of(:frequency) }
  end

end