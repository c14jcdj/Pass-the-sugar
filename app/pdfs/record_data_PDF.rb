class RecordDataPdf

  def initialize(data, diabetic)
    @pdf = Prawn::Document.new
    @weight_data = data[1]
    @glucose_data = data[0]
    @diabetic = diabetic
    logo
    greeting
    weight_graph
    glucose_graph
  end

  def render
    @pdf.render
  end

  private

  def background
    @pdf.fill_color "FFFF99"
    @pdf.fill_rectangle([-50,850], 1150, 900)
    @pdf.fill_color "000000"
  end

  def weight_graph
    @pdf.fill_color "000000"
    @weight_data = Hash[@weight_data.sort]
    x = 1
    @weight_data.each do |date, reading|
      @pdf.table([["WEIGHT"],["Time of reading", "Reading"]]) if x == 1
      @pdf.table([["#{date}", "#{reading}"]])
      x += 1
    end
    @pdf.text '                      '
  end

  def glucose_graph
    @pdf.fill_color "000000"
    @glucose_data = Hash[@glucose_data.sort]
    x = 1
    @glucose_data.each do |date, reading|
      @pdf.table([["GLUCOSE"],["Time of reading", "Reading"]]) if x == 1
      @pdf.table([["#{date}:", "#{reading}"]])
      x += 1
    end
    @pdf.text '                     '
  end

  def logo
    filename = "#{Rails.root}/app/assets/images/small_logo.png"
    @pdf.image filename
  end

  def greeting
    @pdf.stroke_horizontal_rule
    @pdf.text '                     '
    @pdf.text "Data for #{@diabetic.name}"
    @pdf.text '                     '
    @pdf.stroke_horizontal_rule
  end

end