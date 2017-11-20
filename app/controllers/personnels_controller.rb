class PersonnelsController < ApplicationController
	before_action :set_personnel, only: [:show, :edit, :update, :destroy, :choose_position]
	before_action :authenticate_user!
	
	def index
		@personnels = Personnel.paginate(:page => params[:page], :per_page => 5)
	end

	def show
		@schedules = Schedule.where(id: params[:schedule_id])
		@position = @personnel.show_position
		@res_schedule = Resume.next_schedule(params[:id])
		@schedule_able = Schedule.schedule_not(params[:id])
		@position_open = Position.post_choose(params[:id], params[:schedule_id])
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

	def create_account
		@user = User.new
	end

	def save_account
		# render plain: params[:user].inspect
		@user = User.new(create_account_params)
		if @user.save
			redirect_to personnels_url, notice: 'Succesfully create a new account.'
		else
			error =  @user.errors.full_messages
			render :create_account
		end
	end

	private
	def personnel_params
		params.require(:personnel).permit(:name)
	end

	def set_personnel
		@personnel = Personnel.find(params[:id])
	end

	def create_account_params
		params.require(:user).permit(:role, :email, :password, :password_confirmation, :personnel_id)
	end
end