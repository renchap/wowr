$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'wowr_test.rb'

class WowrDungeonTest < WowrTest
	def test_get_arena_team
		arena_team_name = 'cake'
	
		assert_raises Wowr::Exceptions::RealmNotSet do
			@api_empty.get_arena_team(:team_name => arena_team_name)
		end
	
		assert_raises Wowr::Exceptions::ArenaTeamNameNotSet do
			@api_empty.get_arena_team(:realm => "Cake")
		end
	
		assert_raises Wowr::Exceptions::ArenaTeamNameNotSet do
			@api_empty.get_arena_team("", 5)
		end
	
		assert_raises Wowr::Exceptions::InvalidArenaTeamSize do
			@api_empty.get_arena_team(arena_team_name, :realm => "cake")
		end
	
		assert_raises Wowr::Exceptions::InvalidArenaTeamSize do
			@api_empty.get_arena_team(arena_team_name, 9, :realm => "cake")
		end
	
		no_team = Wowr::API.new(:realm => "Barthilas")
		assert_raises Wowr::Exceptions::ArenaTeamNotFound do
			no_team.get_arena_team(arena_team_name, 5)
		end
	
		defaults_api = Wowr::API.new(:character_name => "cake", :realm => "Terenas")
		assert_not_nil defaults_api.get_arena_team(arena_team_name, 5, :realm => "Terenas")
		assert_not_nil defaults_api.get_arena_team(arena_team_name, 5)
		assert_not_nil defaults_api.get_arena_team(arena_team_name, :team_size => 5)
		assert_not_nil defaults_api.get_arena_team(:team_name => arena_team_name, :team_size => 5)
	end
end