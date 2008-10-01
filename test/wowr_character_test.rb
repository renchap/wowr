$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'wowr_test.rb'

class WowrCharacterTest < WowrTest
	def test_character_contents
		
		# Reve::API.cakes = XML_BASE + '.xml'
		character = nil
		assert_nothing_raised do
			character = @api_set.get_character
		end
		
		assert_instance_of Wowr::Classes::FullCharacter, character
				
		assert_not_nil character.name
		assert_not_nil character.level
		assert_not_nil character.char_url
		
		assert_not_nil character.klass
		assert_not_nil character.klass_id
		
		assert_not_nil character.gender
		assert_not_nil character.gender_id
		
		assert_not_nil character.race
		assert_not_nil character.race_id
		
		assert_not_nil character.faction
		assert_not_nil character.faction_id
		
		# If these are empty, they're returned as nil
		# assert_not_nil character.guild
		# assert_not_nil character.guild_url
		# assert_not_nil character.prefix
		# assert_not_nil character.suffix
		
		assert_not_nil character.realm
		
		# This could be nil too
		assert_not_nil character.battle_group
		
		# assert_not_nil character.last_modified
		
		assert_instance_of Wowr::Classes::Agility, character.agi
		assert_instance_of Wowr::Classes::Agility, character.agility
		
		# assert_equals character.agi.base, character.agility.base
		# assert_equals character.agi.armor, character.agility.armor
		
		character.arena_teams do |arena_team|
			
		
		
		end
	end
	
	def test_character_exceptions
		no_data_api = Wowr::API.new
		only_realm_api = Wowr::API.new(:realm => "Stormrage")
		defaults_api = Wowr::API.new(:character_name => "cake", :realm => "Barthilas")
		
		assert_raises Wowr::Exceptions::CharacterNameNotSet do
			no_data_api.get_character
		end
		
		assert_raises Wowr::Exceptions::CharacterNameNotSet do
			only_realm_api.get_character
		end
		
		assert_raises Wowr::Exceptions::RealmNotSet do
			no_data_api.get_character("Phog")
		end
				
		assert_nothing_raised do
			defaults_api.get_character
			only_realm_api.get_character("Phog")
		end
		
		assert_nothing_raised do
			defaults_api.get_character_sheet
			only_realm_api.get_character_sheet("Phog")
		end
		
	end
	
end