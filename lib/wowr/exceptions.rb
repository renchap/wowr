module Wowr
	module Exceptions
		def self.raise_me(code, options = {})
			#msg = "(#{code.to_s}) #{msg}"
			case code
				when "noCharacter"
					raise CharacterNotFound.new("Character '#{options[:character_name]}' not found.")
			end
		end
		
		class InvalidXML < StandardError
		end
		
		class EmptyPage < StandardError
		end
		
		class ServerDoesNotExist < StandardError
			def initialize(string)
				super "Server at '#{string}' did not respond."
			end
		end
		
		class CharacterNameNotSet < StandardError
			def initialize
				super "Character name not set in options or API constructor."
			end
		end
		
		class ArenaTeamNameNotSet < StandardError
			def initialize
				super "Arena team name is not set."
			end
		end
		
		class InvalidArenaTeamSize < StandardError
		end
		
		class RealmNotSet < StandardError
			def initialize
				super "Realm not set in options or API constructor."
			end
		end
		
		# Search (fold)
		class SearchError < StandardError
		end
		
		class InvalidSearchType < StandardError
			def initialize(string)
				super "'' is not a valid search type."
			end
		end
		
		class NoSearchString < StandardError
			def initialize
				super "No search string specified or string was empty."
			end
		end
		
		class CharacterNotFound < StandardError
			def initialize(string)
				super "Character not found with name '#{string}'."
			end
		end
		
		class ItemNotFound < StandardError
			def initialize(string)
				super "Item not found with name '#{string}'."
			end
		end
		
		class GuildNotFound < StandardError
			def initialize(string)
				super "Guild not found with name '#{string}'."
			end
		end
				
		class ArenaTeamNotFound < StandardError
			def initialize(string)
				super "Arena team not found with name '#{string}'."
			end
		end
		# (end)

		

	end
end