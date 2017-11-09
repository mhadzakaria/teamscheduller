class Position < ApplicationRecord
	validates :name, presence: true
	has_and_belongs_to_many :personnels
	has_many :resume, dependent: :destroy

	after_validation do	
		self.name = name.titleize
	end
	# def self.show_pos(personnel)
	# 	return personnel.positions.map{|p| [p.name, p.id]}
	# end

	def self.lead_position
		l = Position.where("name LIKE '%lead%'").map(&:id)
		return l[0]
	end

	def self.singer_position
		l = Position.lead_position
		s = Position.where("name LIKE '%singer%' and id != #{l}").map(&:id)
		return s[0]
	end

	def self.any_singer(id, sch)
		scheObj = Schedule.new
		position = scheObj.position_able(id, sch)
		singer = Position.singer_position
		pos_new = position << singer
		return Position.where(id: pos_new)
	end
end