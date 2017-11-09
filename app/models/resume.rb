class Resume < ApplicationRecord
	belongs_to :personnel
	belongs_to :position
	belongs_to :schedule
	validates_uniqueness_of :schedule_id, scope: [:position_id, :personnel_id]

	def self.count_singer(singer, sch)
		Resume.where(position_id: singer, schedule_id: sch).count
	end

	def self.position_cek(position,sch)
		Resume.where(position_id: position, schedule_id: sch).any?
	end

	scope :pos_sche, ->(singer, sch) {where(position_id: singer, schedule_id: sch)}
end