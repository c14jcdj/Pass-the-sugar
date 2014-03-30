class Doctor < ActiveRecord::Base
	validates_uniqueness_of :name, :scope => [:fax]
	validates_presence_of :name, :fax
	has_many :diabetics
	attr_accessible :name, :fax, :email, :comments
end
