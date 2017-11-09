class Schedule < ApplicationRecord
	FORMAT = [
		[1, 2, 3, 4, 5, 6, 6, 6],
		[2, 3, 4, 5, 6, 6, 6],
		[1, 2, 4, 5, 6, 6, 6],
		[1, 4, 5, 6, 6, 6]
	]

	validates :perform_date, uniqueness: true
	has_many :resume, dependent: :destroy

	# def self.jumlah_posisi(id)
	# 	personnel = Personnel.find(id)
	# 	return personnel.positions.count
	# end

	def self.checking_formation(format=[])
		format = format.kind_of?(Array) ? format.sort : []

		return 'Band siap manggung' if [0,1,2].include?(FORMAT.index(format))
		return 'Band siap manggung, tapi anda yakin tidak akan menambahkan drummer?' if FORMAT.index(format) == 3
		return 'Posisi kosong' if format == []
		'Posisi belum terisi sempurna'
	end

	def empt_array(id, sch)
		personnel = Personnel.find(id)
		array = Schedule.per_array(personnel)
		cek = Schedule.sche_array(sch, array)
	end

	def self.schedule_not(id)
		resume = Resume.where(personnel_id: id).map(&:schedule_id)
		return Schedule.where.not(id: resume).order(perform_date: :asc)
	end

	def self.res_position(id)
		Resume.joins(:personnel, :position, :schedule).where(schedule_id: id)
	end

	def self.schedule_format(schedule)
		format = Resume.order(position_id: :asc).where(schedule_id: schedule).map(&:position_id)
		checking_formation(format)
		

		# elsif FORMAT.index(format) == 3
		# 	'Band siap manggung, tapi anda yakin tidak akan menambahkan drummer?'
		# elsif format == []
		# 	'Posisi kosong'
		# else
		# 	'Posisi belum terisi sempurna'
		# end
	end

	def position_open(id, sch)
		personnel = Personnel.find(id)
		array = Schedule.per_array(personnel)
		cek = Schedule.sche_array(sch, array)
		array_cek = array - cek
		return Position.where(id: array_cek)
	end

	def self.singer_pos(id, sch)
		return Position.where(id: 6)
	end


	def position_able(id, sch)
		personnel = Personnel.find(id)
		array = Schedule.per_array(personnel)
		cek = Schedule.sche_array(sch, array)
		array_cek = array - cek
		if array_cek == [] #kembalikan array position_id personnel jika hasil kurang jadi array kosong
			return array
		else
			return array_cek
		end
	end

	def self.sche_array(sch, array)
		Resume.where(schedule_id: sch, position_id: array).map(&:position_id)
	end

	def self.per_array(personnel)
		personnel.positions.map(&:id)
	end

	def self.take_position(position, personel, sch, id)
		if position.include? personel || position == [personel] #kalau posisi berisi id singer
			if Resume.pos_sche(personel, sch).count < 3 #cek singer udah tiga?
				[Schedule.singer_pos(id, sch), nil, nil] 
			else
				[nil, 'Posisi Singer sudah terisi penuh.', "choose_schedule_personnel_url(params[:id])"]
			end
		else
			[nil, 'Posisi sudah penuh', "personnel_path(params[:id])"]
		end
	end
end