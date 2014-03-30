class RecordsController < ApplicationController

  before_filter :redirect_if_logged_out, :load_diabetic
  before_filter :load_record, :except => [:index, :new, :create]

  def index
    respond_to do |format|
      format.html do
        render :partial => 'records/index', locals: { records: @diabetic.records, diabetic: @diabetic, account: current_account }
      end
      format.pdf do
        @data = @diabetic.get_data_for_pdf
        pdf = RecordDataPdf.new(@data, @diabetic)
        send_data pdf.render, filename: "#{@diabetic.name}_#{Time.now.strftime("%Y-%m-%d")}", type: "application/pdf"
      end
    end
  end

  def show
    render partial: "records/show", locals: {record: @record, diabetic: @diabetic}
  end

  def new
    @record = Record.new
    render partial: 'records/new', locals: {record: @record, diabetic: @diabetic}
  end

  def create
    @record = @diabetic.records.build(params[:record])
    if @record.save
      ok = true
      path = dashboard_path
    end
    render_json(!!ok, path, @record.errors.full_messages)
  end

  def edit
    render partial: 'records/edit', locals: {record: @record, diabetic: @diabetic}
  end

  def update # Unused
    @record.assign_attributes(params[:record])
    if @record.save
      path = dashboard_path
      ok = true
    end
    render_json(!!ok, path, @record.errors.full_messages)
  end

  def destroy
    @record.destroy
    ok = true
    render_json(!!ok, dashboard_path, @record.errors.full_messages)
  end

  private

  def load_diabetic
    @diabetic = Diabetic.find(params[:diabetic_id])
  end

  def load_record
    @record = Record.find(params[:id])
  end

end
