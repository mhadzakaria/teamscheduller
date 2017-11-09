class SchedulesController < ApplicationController
	before_action :authenticate_user!

	def index
		@schedules = Schedule.all.order(perform_date: :asc)
	end

	def show
		@schedule = Schedule.find(params[:id])
	end

	def new
		@schedule = Schedule.new
		@date = ScheduleHelper.range
	end

	def create
		# render plain: params[:schedule].inspect
		@schedule = Schedule.new(schedule_params)
		if @schedule.save
			redirect_to schedules_url, notice: 'Penyimpanan posisi berhasil'
		else
			render :new
		end
	end

	def choose_schedule
		@schedules = Schedule.all.order(perform_date: :asc)
	end

	def choose_position_sch
		sch = params[:resume][:schedule_id]
		id = params[:id]
		singer = Position.singer_position
		scheObj = Schedule.new
		position = scheObj.position_able(id, sch)

		# personnel = Personnel.find(id)
		# if Schedule.per_array(personnel).length == 1
		# 	if Resume.position_cek(position,sch)
		# 		@personnel  = scheObj.positions_open(id, sch)
		# 	else
		# 		p = position[0]
		# 		save_instant(sch, id, p)
		# 	end
		# else
			
		# end


		if Resume.position_cek(position,sch)#posisi terisi
			if position.length > 1#posisi lebih dari satu
				if scheObj.empt_array(id, sch) == [] #cek posisi setalh di kurang yg tersedia kosong
					position_singer(position, singer, sch)
				else
					@personnel  = scheObj.position_open(id, sch)
				end
			else#posisi cuma satu
				position_singer(position, singer, sch)
			end
		else#posisi belum terisi
			if position.length == 1#posisi cuma satu
				if Resume.pos_sche(singer, sch).count < 3 #cek singer udah tiga?
					@personnel  = Position.any_singer(id, sch)
				else
					p = position[0]
					save_instant(sch, id, p)
				end
			else
				@personnel  = scheObj.position_open(id, sch)
			end
		end
	end

	private

	def position_singer(position, singer, sch)
		@personnel, notice, url = Schedule.take_position(position, singer, sch, params[:id])

		redirect_to eval(url), notice: notice  if @personnel.nil?
	end

	def save_instant(sch, id, p)
		@resume = Resume.new(schedule_id: sch, personnel_id: id , position_id: p)
		if @resume.save
			redirect_to schedules_url, notice: 'Penyimpanan posisi berhasil'
		else
			@schedules = Schedule.all.order(perform_date: :asc)
			redirect_to personnel_url(params[:id]) , notice: 'Penyimpanan posisi gagal'
		end
	end

	def schedule_params
		params.require(:schedule).permit(:perform_date)
	end

end