class PositionsController < ApplicationController
	before_action :set_position, only: [:edit, :update, :destroy]	
	before_action :authenticate_user!

	def index
		@positions = Position.all
	end

	def new
		@position = Position.new
	end

	def create
		# render plain: params[:position].inspect
		@position = Position.new(position_params)
		if @position.save
			redirect_to positions_url, notice: 'Sukses buat Position'
		else
			render :new, notice: 'Gagal buat Position'
		end
	end

	def edit
	end

	def update
		if @position.update(position_params)
			redirect_to positions_url, notice: 'Sukses update Position'
		else
			render :edit, notice: 'Gagal update Position'
		end
	end

	def destroy
		@position.destroy
		redirect_to positions_url, notice: 'Sukses hapus Position'
	end

	private
	def position_params
		params.require(:position).permit(:name)
	end
	def set_position
		@position = Position.find(params[:id])
	end
end