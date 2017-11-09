class PersonnelsController < ApplicationController
	before_action :set_personnel, only: [:show, :edit, :update, :destroy, :choose_position]
	before_action :authenticate_user!
	
	def index
		@personnels = Personnel.all
	end

	def show
		@schedules = Schedule.where(id: params[:id])
		@position = @personnel.positions.collect(&:name)
		@res_schedule = Resume.joins(:schedule, :position).where(personnel_id: params[:id])
		@schedule_able = Schedule.schedule_not(params[:id])
	end

	def new
		@personnel = Personnel.new
	end

	def create
		# render plain: params[:personnel].inspect
		@personnel = Personnel.new(personnel_params)
		if @personnel.save
			redirect_to @personnel, notice: 'Sukses buat Personnel'
		else
			render :new, notice: 'Gagal buat Personnel'
		end
	end

	def edit
	end

	def update
		if @personnel.update(personnel_params)
			redirect_to @personnel, notice: 'Sukses update Personnel'
		else
			render :edit, notice: 'Gagal buat Personnel'
		end

	end

	def destroy
		@personnel.destroy
		redirect_to personnels_path, notice: 'Sukses hapus Personnel'
	end

	def choose_position
		@positions = Position.all		
	end

	def add_position
		# render plain: params[:c_pos].inspect

		@position = Position.find(params[:c_pos][:position_id])
		@personnel = Personnel.find(params[:c_pos][:personnel_id])

		@personnel.positions << @position
		redirect_to personnels_path
	end

	private
	def personnel_params
		params.require(:personnel).permit(:name)
	end

	def set_personnel
		@personnel = Personnel.find(params[:id])
	end
end