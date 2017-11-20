class ResumesController < ApplicationController
	before_action :authenticate_user!

	def destroy
		@resume = Resume.find(params[:id])
		@resume.destroy
		redirect_to schedules_url, notice: 'Berhasil hapus'
	end

	def create
		# render plain: params[:resume].inspect
		position_id = params[:resume][:position_id]
		schedule_pilih = Schedule.find(params[:resume][:schedule_id])
		lead = Position.lead_position#atau ganti dengan 5
		array_sch = Schedule.where("perform_date LIKE '%-#{schedule_pilih.perform_date.mon}-%'").map(&:id) #mencari id dengan bulan pada tgl terpilih untuk menentukan lead 1x 1bulan

		if Resume.find_position_lead(params[:resume][:personnel_id], array_sch, lead).any?
			if position_id == lead
				redirect_to personnel_url(position_id), notice: 'Personnel hanya boleh menjadi Lead Singer 1x dalam 1 bulan'
			else
				save_form
			end
		else
			save_form
		end
	end

	def save_form
		personnel_id = params[:resume][:personnel_id]
		schedule_id = params[:resume][:schedule_id]
		position_id = params[:resume][:position_id]
		name = Personnel.find_name(personnel_id)
		position = Position.find_position(position_id)
		@resume = Resume.new(resume_params)
		if @resume.save
			redirect_to personnel_url(personnel_id, schedule_id: schedule_id), notice: "Menambahkan #{name} ke jadwal sebagai #{position} berhasil"
		else
			redirect_to personnel_url(params[:resume][:position_id]), notice: 'Gagal'
		end
	end

	private
	def resume_params
		params.require(:resume).permit(:schedule_id, :personnel_id, :position_id)
	end

end
