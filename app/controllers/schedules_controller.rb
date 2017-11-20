class SchedulesController < ApplicationController
	before_action :authenticate_user!
	before_action :creat_automatically

	def index
		@schedules = Schedule.all.paginate(:page => params[:page], :per_page => 5)
		
	end

	def upcoming
		@schedules = Schedule.list_schedule('>').paginate(:page => params[:page], :per_page => 5)		
	end


	def export_excel
		@schedulez, @note = Schedule.export_schedule(params[:range], params[:note])

		@positions = Position.all
		respond_to do |format|
			format.html
			format.xlsx
			format.pdf {render template: 'schedules/pdf', pdf: 'file'}
		end		
	end

	def export_pdf
		@schedules = Schedule.all
		respond_to do |format|
	      format.html
	      format.pdf do
      	  pdf = ExportPdf.new(@schedules, 'ada')
	        send_data pdf.render,
	          filename: "export.pdf",
	          type: 'application/pdf',
	          disposition: 'inline'
	      end
	    end
	end

	def history
		@schedules = Schedule.list_schedule('<')
	end

	def show
		@schedule = Schedule.find(params[:id])
	end

	def new
		@schedule = Schedule.new
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
		singer = Position.personnel_position
		position = Position.position_able(id, sch)

		personnel = Personnel.find(id)
		position_personnel = Position.per_array(personnel)#poisinya apa aja
		if position_personnel.length == 1
			if Resume.position_cek(position_personnel,sch)
				redirect_to personnel_url(id, schedule_id: sch), notice: 'penuh'
			else
				p = position[0]
				save_instant(sch, id, p)
			end
		else
			if position_personnel.include? singer
				position_singer(position, singer, sch)
			else
				if Position.position_open(id, sch) == []
					redirect_to personnel_url(id, schedule_id: sch), notice: 'penuh'
				else
					redirect_to personnel_url(id, schedule_id: sch)
				end
			end
		end


		# if Resume.position_cek(position,sch)#posisi terisi
		# 	if position.length > 1#posisi lebih dari satu
		# 		if scheObj.empt_array(id, sch) == [] #cek posisi setalh di kurang yg tersedia kosong
		# 			position_singer(position, singer, sch)
		# 		else
		# 			@personnel  = Position.position_open(id, sch)
		# 		end
		# 	else#posisi cuma satu
		# 		position_singer(position, singer, sch)
		# 	end
		# else#posisi belum terisi
		# 	if position.length == 1#posisi cuma satu
		# 		if Resume.pos_sche(singer, sch).count < 3 #cek singer udah tiga?
		# 			@personnel  = Position.any_singer(id, sch)
		# 		else
		# 			p = position[0]
		# 			save_instant(sch, id, p)
		# 		end
		# 	else
		# 		@personnel  = Position.position_open(id, sch)
		# 	end
		# end
	end

	def creat_automatically
		date = Date.today
		plus = date + 14
		if plus.saturday?
			Schedule.create(perform_date: plus) if Schedule.find_by(perform_date: date).blank?
		end
	end

	private

	def position_singer(position, singer, sch)
		@personnel, notice, url = Position.take_position(position, singer, sch, params[:id])

		redirect_to eval(url), notice: notice  if @personnel.nil?
	end

	def save_instant(sch, id, p)
		@resume = Resume.new(schedule_id: sch, personnel_id: id , position_id: p)
		if @resume.save
			redirect_to personnel_url(id, schedule_id: sch), notice: 'Penyimpanan posisi berhasil'
		else
			@schedules = Schedule.order(perform_date: :asc)
			redirect_to personnel_url(id) , notice: 'Penyimpanan posisi gagal'
		end
	end

	def schedule_params
		params.require(:schedule).permit(:perform_date)
	end

end