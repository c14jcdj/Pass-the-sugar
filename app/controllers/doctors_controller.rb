class DoctorsController < ApplicationController

	before_filter :load_diabetic, :redirect_if_logged_out
	before_filter :load_doctor, :except => [:index, :new, :create,]

	def new
		@doctor = Doctor.new
		@title = "Create a doctor"
		render :partial => 'doctors/new', locals: {
																									diabetic: @diabetic,
																									doctor: @doctor,
																									title: 'Doctor Creation'
																								}
	end

	def create
		@doctor = Doctor.find_or_initialize_by_name_and_fax(params[:doctor])
		@diabetic.doctor = @doctor
		if @doctor.save
			@diabetic.save
			ok = true
			path = new_diabetic_preference_path(diabetic_id: @diabetic.id)
		end
		render_json(!!ok, path, @doctor.errors.full_messages)

	end

	def edit
		render :partial => 'doctors/edit', locals: {
																									diabetic: @diabetic,
																									doctor: @doctor,
																									title: 'Edit a doctor'
																								}
	end

	def update
		@doctor.assign_attributes(params[:doctor])
		if @doctor.save
			ok = true
			path = dashboard_path
		end
		render_json(!!ok, path, @doctor.errors.full_messages)
	end

	def destroy
		render_json(!!ok, dashboard_path, @doctor.errors.full_messages)
	end

	private

	def load_diabetic
		@diabetic = Diabetic.find(params[:diabetic_id])
	end

	def load_doctor
		@doctor = Doctor.find(params[:id])
	end
end
