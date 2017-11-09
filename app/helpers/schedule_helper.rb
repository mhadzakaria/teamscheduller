module ScheduleHelper
	def self.range
		now = Date.today()
		akhir = Date.new(2017,12,31) 
		date = (now.at_beginning_of_month..akhir.at_end_of_month)
	end
end
