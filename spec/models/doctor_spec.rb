require 'spec_helper'

describe Doctor do
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).scoped_to(:fax) }
  it { should have_many :diabetics }
end