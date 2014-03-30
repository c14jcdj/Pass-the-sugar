class Diabetic < ActiveRecord::Base
  attr_accessible :name, :email, :birthday

  # Validations
  validates_presence_of :name, :email, :birthday
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^\w+[\.\w\-]*@\w+\.\w{2,5}$/
  validate :birthday_cant_be_in_the_future

  # Associations
  belongs_to :account
  belongs_to :doctor
  has_many :records
  has_one :preference

  after_initialize :convert_birthday

  def age
    age = Date.today.year - self.birthday.year
    age -= 1 if Date.today < self.birthday.year + age.years
  end

  def get_data_for_graph(number_of_days=7, format = '%a %m/%d')
    collection = load_records(number_of_days)
    get_data_2(collection)
  end

def get_data_2(collection)
    #could take an argument for a range of data
     glucose_graph_data = {}
     comment_graph_data = {}
     weight_graph_data = {}
     collection.each do |record|
       glucose_graph_data[record.taken_at.localtime.to_s] = record.glucose.to_i if record.glucose.to_i
       comment_graph_data[record.taken_at.localtime.to_s] = record.comment
       weight_graph_data[record.taken_at.localtime.to_s] = record.weight.to_i if record.weight.to_i
     end
     [glucose_graph_data, comment_graph_data,  weight_graph_data]
  end


  def get_data_for_pdf(number_of_days=14)
    collection = load_records(number_of_days)
    get_data(collection, '%m/%d/%y -- %I:%M %p')
  end

  def sort_graph_data
    glucose_data = self.get_data_for_graph.first.sort_by{|a,b| a }
    comment_data = self.get_data_for_graph[1].sort_by{|a,b| a}
    weight_data = self.get_data_for_graph.last.sort_by{|a,b| a }
    glucose_data = Hash[*glucose_data.flatten]
    weight_data = Hash[*weight_data.flatten]
    comment_data = Hash[*comment_data.flatten]
    [glucose_data, comment_data, weight_data]
  end

  private

  def load_records(number_of_days=7)
    self.records.where(taken_at: (Time.now.midnight - number_of_days.days)..Time.now.midnight)
  end

  def get_data(collection, format='')
    #could take an argument for a range of data
     glucose_graph_data = {}
     weight_graph_data = {}
     collection.each do |record|
       glucose_graph_data[record.taken_at.localtime.strftime(format).to_s] = record.glucose.to_i if record.glucose.to_i
       weight_graph_data[record.taken_at.localtime.strftime(format).to_s] = record.weight.to_i if record.weight.to_i
     end
     [glucose_graph_data, weight_graph_data]
  end

  def birthday_cant_be_in_the_future
    if birthday.present? && birthday >= Date.today
      errors.add(:birthday, "must be before today")
    end
  end

  def convert_birthday
    if self.birthday.is_a? Hash
      self.birthday = Date.parse(self.birthday.values.join('-'))
    end
  end



end
