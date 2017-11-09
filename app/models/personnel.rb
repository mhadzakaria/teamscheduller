class Personnel < ApplicationRecord
	validates :name, presence: true
	has_and_belongs_to_many :positions
	has_many :resume, dependent: :destroy

	after_validation do	
		self.name = name.titleize
	end

	def self.hitung_posisi(personnel)
		Personnel.find(personnel).positions.count
	end
end