module Wowr
	module Exceptions
		def self.raise_me(code, options = {})
			case code
				when "noCharacter"
					raise CharacterNotFound.new("Character '#{options[:character_name]}' not found.")
				else
					raise StandardError.new("The XML returned an error: #{code.to_s}")
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
				super "Arena team name not set."
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
		
		class InvalidSearchType < SearchError
			def initialize(string)
				super "'#{string}' is not a valid search type."
			end
		end
		
		class NoSearchString < SearchError
			def initialize
				super "No search string specified or string was empty."
			end
		end
		
		class ElementNotFoundError < StandardError
		end
		
		class CharacterNotFound < ElementNotFoundError
			def initialize(string)
				super "Character not found with name '#{string}'."
			end
		end
		
		class ItemNotFound < ElementNotFoundError
			def initialize(string)
				super "Item not found with name '#{string}'."
			end
		end
		
		class GuildNotFound < ElementNotFoundError
			def initialize(string)
				super "Guild not found with name '#{string}'."
			end
		end
				
		class ArenaTeamNotFound < ElementNotFoundError
			def initialize(string)
				super "Arena team not found with name '#{string}'."
			end
		end
		# (end)

		class InvalidIconSize < StandardError
			def initialize(array)
				super "Icon size must be: #{array.keys.inspect}"
			end
		end
		
		class InvalidIconType < StandardError
			def initialize(array)
				super "Icon type must be: #{array.keys.inspect}"
			end
		end
	end
end