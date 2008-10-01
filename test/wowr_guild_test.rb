$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'wowr_test.rb'

class WowrGuildTest < WowrTest
	def test_guild
		assert_not_nil @api_set.get_guild
		assert_not_nil @api_set.get_guild("cake")
		assert_not_nil @api_set.get_guild("Moo", :realm => "Black Dragonflight")
		assert_not_nil @api_set.get_guild(:guild_name => "Moo", :realm => "Black Dragonflight")
	
		assert_raises Wowr::Exceptions::GuildNameNotSet do
			@api_empty.get_guild
		end
	
		assert_raises Wowr::Exceptions::RealmNotSet do
			@api_empty.get_guild("cake")
		end

		assert_not_nil @api_empty.get_guild("Moo", :realm => "Black Dragonflight")
		assert_not_nil @api_empty.get_guild(:guild_name => "Moo", :realm => "Black Dragonflight")
	
		assert_instance_of Wowr::Classes::FullGuild, @api_empty.get_guild("Moo", :realm => "Black Dragonflight")
		assert_instance_of Wowr::Classes::SearchGuild, @api_empty.search_guilds("Moo").first
	end
end