class Graph < ActiveRecord::Base

  def self.last_date(array)
    last_date = array.first
    last_date = (Date.parse(last_date)).to_s
    last_date.split.first.split("-")
  end

  def self.format_days(days)
    days_formatted = []
    days.each do |day|
      str = Date.parse(day)
      days_formatted << str.strftime('%b/%d')
    end
    days_formatted
  end

  def get_graph_data
    @data = @diabetic.get_data_for_graph
    @data.to_json
  end

end
