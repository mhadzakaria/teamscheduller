class ResumesController < ApplicationController
	before_action :authenticate_user!

	def destroy
		@resume = Resume.find(params[:id])
		@resume.destroy
		redirect_to schedules_url, notice: 'Berhasil hapus'
	end

	def create
		# render plain: params[:resume].inspect
		schedule_pilih = Schedule.find(params[:resume][:schedule_id])
		lead = Position.lead_position#atau ganti dengan 5
		array_sch = Schedule.where("perform_date LIKE '%-#{schedule_pilih.perform_date.mon}-%'").map(&:id) #mencari id dengan bulan pada tgl terpilih untuk menentukan lead 1x 1bulan

		if Resume.where(personnel_id: params[:resume][:personnel_id], schedule_id: array_sch, position_id: lead).any?
			if params[:resume][:position_id] == lead
				redirect_to choose_schedule_personnel_url(params[:resume][:position_id]), notice: 'Personnel hanya boleh menjadi Lead Singer 1x dalam 1 bulan'
			else
				save_form
			end
		else
			save_form
		end
	end

	def save_form
		@resume = Resume.new(resume_params)
		if @resume.save
			redirect_to schedules_url, notice: 'Penyimpanan posisi berhasil'
		else
			redirect_to choose_schedule_personnel_url(params[:resume][:position_id]), notice: 'Gagal'
		end
	end

	private
	def resume_params
		params.require(:resume).permit(:schedule_id, :personnel_id, :position_id)
	end

end
