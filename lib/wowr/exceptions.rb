module Wowr
	module Exceptions
		def self.raise_me(code)
			#msg = "(#{code.to_s}) #{msg}"
			case code
				when "noCharacter"
					raise CharacterNotFound.new("Character with that name not found.")
			end
		end
		
		class InvalidXML < StandardError
		end
		
		# errCode="noCharacter"
		class CharacterNotFound < StandardError
		end
		
		class ItemNotFound < StandardError
		end
		
		class GuildNotFound < StandardError
		end
		
		class InvalidSearchType < StandardError
		end
		
		class NoSearchString < StandardError
		end
		
		class InvalidArenaTeamSize < StandardError
		end
	end
end