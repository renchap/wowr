module Wowr
	# All of these are shamelessly nicked from Ruby on Rails. 
	# The String Extensions have a bit more fault tolerance.
	module Extensions
		module String
			def to_time(form = :utc)
				begin
					::Time.send(form, *ParseDate.parsedate(self))
				rescue TypeError
					self
				end
			end
		end
	end
end