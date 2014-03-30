class PreferencesController < ApplicationController
  before_filter :load_diabetic
  before_filter :load_preference, :except => [ :new, :create ]
  before_filter :find_or_create_preference, :only => [ :create ]

  def new
    @preference = Preference.new
    render :partial => 'preferences/new', locals: {
                                                          diabetic: @diabetic,
                                                          preference: @preference
                                                        }
  end

  def create
    if @preference.save
      @diabetic.save
      ok = true
      path = dashboard_path
    end
    render_json(!!ok, path, alert)
  end

  def show
    render :partial => 'preferences/show', locals: {
                          diabetic: @diabetic,
                          preference: @preference
                        }
  end

  def edit
    render :partial => 'preferences/edit', locals: {
                                                          title: "Modify a doctor",
                                                          diabetic: @diabetic,
                                                          preference: @preference
                                                        }
  end

  def update
    if @preference.update_attributes(params[:preference])
      ok = true
      path = dashboard_path
    end
    render_json(!!ok, path, @preference.errors.full_messages)

  end

  private

  def load_diabetic
    @diabetic = Diabetic.find(params[:diabetic_id])
  end

  def load_preference
    @preference = @diabetic.preference
  end

  def find_or_create_preference
    if @diabetic.preference
      @preference = @diabetic.preference
    else
      @preference = Preference.new(params[:preference])
    end
    @diabetic.preference = @preference
  end
end
