require 'spec_helper'

describe RecordDataPdf do
  context 'Instantiation' do
    it "should be instantiate properly" do
      @chris = Diabetic.create({name:'chris', email:'chris@dbc.com', birthday: Date.today-20000 }, :without_protection => true)
      @record1 = Record.create(glucose: '100', weight: '175', taken_at: (Time.now-500))
      @chris.records << @record1
      data = @chris.get_data_for_graph
      pdf  = RecordDataPdf.new(data, @chris)
      expect(pdf).to be_a RecordDataPdf
    end
  end
end