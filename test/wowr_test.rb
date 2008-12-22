require 'test/unit'
require '../lib/wowr.rb'
require 'yaml'


XML_BASE = File.join(File.dirname(__FILE__) + '/xml/')
SAVE_PATH = File.join(File.dirname(__FILE__),'downloads')

module Wowr
	class API

		@@cache_directory_path = 'test_cache/'
				
		# def get_xml(url, opts = {})
		# 	response = File.open(url,'r')
		# 	begin
		# 		doc = Hpricot.XML(response)
		# 		# xml = check_exception(response)
		# 		# ret = []
		# 		# return xml if just_xml
		# 		# xml.search("//rowset/row").each do |elem|
		# 		# 	ret << klass.new(elem)
		# 		# end
		# 		# ret
		# 	ensure
		# 		response.close
		# 		
		# 	end
		# end

		# def process_query(klass,url,just_xml,args = {})
		# 	response = File.open(url,'r')
		# 	@last_hash = compute_hash(args.merge({:url => url, :just_hash => true })) # compute hash
		# 	begin
		# 		xml = check_exception(response)
		# 		ret = []
		# 		return xml if just_xml
		# 		xml.search("//rowset/row").each do |elem|
		# 			ret << klass.new(elem)
		# 		end
		# 		ret
		# 	ensure
		# 		response.close
		# 	end
		# end
	end
end


class WowrTest < Test::Unit::TestCase

	def setup
		@api_empty = Wowr::API.new
		@api_set = Wowr::API.new(:character_name => 'Clublife', :realm => "Barthilas", :guild_name => "Cake")
		@api_no_cache = Wowr::API.new(:caching => false)
	end
	
  def teardown
		@api_set.clear_cache
    FileUtils.rm_rf(SAVE_PATH)
  end
	
	def test_api_defaults
		assert_nil @api_empty.character_name
		assert_nil @api_empty.guild_name
		assert_nil @api_empty.realm
		
		assert_equal @api_empty.locale, 'us'
		assert_equal @api_empty.lang, 'default'
		assert_equal @api_empty.caching, true
		assert_equal @api_empty.cache_timeout, (7*24*60*60)
		assert_equal @api_empty.debug, false
	end
	
	def test_api_constants
		assert_equal Wowr::API.armory_base_url, 'wowarmory.com/'
		
		assert_equal Wowr::API.search_url, 'search.xml'
		
		assert_equal Wowr::API.character_sheet_url, 'character-sheet.xml'
		assert_equal Wowr::API.character_talents_url, 'character-talents.xml'
		assert_equal Wowr::API.character_reputation_url, 'character-reputation.xml'
		
		assert_equal Wowr::API.guild_info_url, 'guild-info.xml'
		
		assert_equal Wowr::API.item_info_url, 'item-info.xml'
		assert_equal Wowr::API.item_tooltip_url, 'item-tooltip.xml'
		
		assert_equal Wowr::API.arena_team_url, 'team-info.xml'
		
		assert_equal Wowr::API.guild_bank_contents_url, 'vault/guild-bank-contents.xml'
		assert_equal Wowr::API.guild_bank_log_url, 'vault/guild-bank-log.xml'
		
		assert_equal Wowr::API.login_url, 'login/login.xml'
		
		assert_equal Wowr::API.max_connection_tries, 10
		
		assert_equal Wowr::API.cache_directory_path, 'test_cache/'
		
		assert_equal Wowr::API.default_cache_timeout, (7*24*60*60)
		assert_equal Wowr::API.failed_cache_timeout, (60*60*24)
	end

	def test_api_params
		api = Wowr::API.new(:character_name => 'foo',
												:guild_name => 'bar',
												:realm => 'baz',
												:locale => 'hoge',
												:lang => 'hogehoge',
												:caching => false,
												:debug => true)
		
		assert_equal api.character_name, 'foo'
		assert_equal api.guild_name, 'bar'
		assert_equal api.realm, 'baz'
		assert_equal api.locale, 'hoge'
		assert_equal api.lang, 'hogehoge'
		assert_equal api.caching, false
		assert_equal api.debug, true
	end

	def test_no_server
		api = Wowr::API.new(:locale => 'hoge')
		
		assert_raises Wowr::Exceptions::ServerDoesNotExist do
			api.search_characters(:search => 'cake')
		end
	end
	
	def test_no_item
		assert_raises Wowr::Exceptions::ItemNotFound do
			@api_empty.get_item_info(:item_id => 9999999)
		end
		
		assert_raises Wowr::Exceptions::ItemNotFound do
			@api_empty.get_item_info(9999999)
		end		
	end
	
	def test_blah
		item_id = 24032
		options = {:lang => 'fr_fr'}
		y1 = @api_empty.get_item_tooltip(item_id)
		y2 = @api_empty.get_item_tooltip(:item_id => item_id, :lang => 'fr_fr')
		y3 = @api_empty.get_item_tooltip(item_id, {:lang => 'fr_fr'})
		y4 = @api_empty.get_item_tooltip(item_id, options)
		
		# assert_equal y1, y2
		# assert_equal y2, y3
		# assert_equal y3, y4
	end
	
	def test_searching
		assert_not_nil @api_empty.search_characters("cake")
		assert_not_nil @api_empty.search_items("cake")
		assert_not_nil @api_empty.search_guilds("cake")
		assert_not_nil @api_empty.search_arena_teams("cake")
		
		# Some results found
		assert_not_equal @api_empty.search_characters("cake"), []
		assert_not_equal @api_empty.search_items("cake"), []
		assert_not_equal @api_empty.search_guilds("cake"), []
		assert_not_equal @api_empty.search_arena_teams("cake"), []
		
		assert_raises Wowr::Exceptions::NoSearchString do
			@api_empty.search("")
		end
		
		assert_raises Wowr::Exceptions::InvalidSearchType do
			@api_empty.search("Hi")
		end
		
		assert_raises Wowr::Exceptions::InvalidSearchType do
			@api_empty.search("Hi", :type => 'cakes')
		end
		
		assert_raises ArgumentError do
			@api_empty.search_characters
		end
		
		assert_raises ArgumentError do
			@api_empty.search_items
		end

		assert_raises ArgumentError do
			@api_empty.search_guilds
		end
		
		assert_raises ArgumentError do
			@api_empty.search_arena_teams
		end
	end
	
	
	
	
	# def test_character
	# 	
	# 	char = defaults_api.get_character_sheet
	# 	
	# 	assert_not_nil char
	# 	
	# 	assert_equals char, defaults_api.get_character_sheet("cake")
	# 	
	# 	assert_not_nil defaults_api.get_character_sheet("cake")
	# 	assert_not_nil defaults_api.get_character_sheet("Phog")
	# 	
	# 	phog = assert_not_nil defaults_api.get_character_sheet("Phog")
	# 	
	# 	defaults_api.get_character_sheet("Phog", :realm => "Stormrage")
	# 	
	# 	api2.get_character_sheet("Phog") # should be ok
	# 	api.get_character_sheet("cake", :realm => "Barthilas")
	# 	api2.get_character_sheet("cake", :realm => "Barthilas")
	# 	api.get_character_sheet(:character_name => "cake", :realm => "Barthilas")
	# 	api2.get_character_sheet(:character_name => "cake", :realm => "Barthilas")
	# end
	# 
	# 



	# ensure that the requested language is being returned
	def test_languages
		language = 'fr_fr'
		api = Wowr::API.new(:lang => language)
		
		returned_language = 'fr_fr'
		
		assert_equal language, returned_language
	end

	def test_caching
		
	end
	
	

	# def test_bad_xml
	# 	Wowr::API.character_sheet_url = XML_BASE + 'bad_character.xml'
	# 	skill = @api.skill_in_training
	# 	assert_not_nil @api.last_hash
	# end
	# 
	# def test_item
	# 	
	# end
	# 
	
	
	def test_item
		item = @api_empty.get_item_info(4336)
	end
	
	
	def test_item_api_references
		
	end
	# 
	# 
	# def test_character_sheet
	# 	Wowr::API.character_sheet_url = XML_BASE + 'character-sheet.xml'
	# 	#Reve::API.conqurable_outposts_url = XML_BASE + 'conqurable_stations.xml'
	# 	character = nil
	# 	assert_nothing_raised do
	# 		character = @api.get_character_sheet
	# 	end
	# 
	# 	assert_not_nil character.title
	# 	assert_not_nil character.health
	# 	
	# 	test_second_bar(character.second_bar)
	# 	
	# 	assert_instance_of Wowr::Classes::Strength, character.strength
	# 	
	# 	test_strength(character.strength)
	# 	test_agility(character.agility)
	# 	test_stamina(character.stamina)
	# 	test_intellect(character.intellect)
	# 	test_spirit(character.spirit)
	# 	
	# 	test_melee(character.melee)
	# 	test_ranged(character.ranged)
	# 	test_spell(character.spell)
	# 	test_defenses(character.defenses)
	# 	
	# 	character.professions do |prof|
	# 		test_professions(prof)
	# 	end
	# 	
	# 	character.items do |item|
	# 		test_equipped_item(item)
	# 	end
	# 	
	# 	character.buffs do |buff|
	# 		test_buffs_debuffs(buff)
	# 	end
	# 	
	# 	character.debuffs do |debuff|
	# 		test_buffs_debuffs(debuff)
	# 	end
	# end
	# 	
	# def test_second_bar
	# 	
	# end
	# 
	# def test_strength(strength)
	# 	attrs = ["base", "effective", "attack", "block"]
	# 	
	# 	attrs do |att|
	# 		assert_not_nil strength.att
	# 	end
	# end
	# 
	# def test_agility
	# 	
	# end
	# 
	# def test_stamina
	# 	
	# end
	# 
	# def test_intellect
	# 	
	# end
	# 
	# def test_spirit
	# 	
	# end
	# 
	# def test_melee
	# 	
	# end
	# 
	# def test_ranged
	# 	
	# end
	# 
	# def test_spell
	# 	
	# end
	# 
	# def test_defenses
	# 	
	# end
	# 
	# def test_profession
	# 	
	# end
	# 
	# def test_equipped_item
	# 	
	# end
	# 		# # TODO: Massive problem, doesn't fill in resistances for some reason
	# 		# resist_types = ['arcane', 'fire', 'frost', 'holy', 'nature', 'shadow']
	# 		# @resistances = {}
	# 		# resist_types.each do |res|
	# 		#		@resistances[res] = Resistance.new(elem%'resistances'%res)
	# 		# end
	# 		# 
	# 		# @talent_spec = TalentSpec.new(elem%'talentSpec')
	# 		# 
	# 		# @pvp = Pvp.new(elem%'pvp')
	# 						
	# 
	# def test_buffs_debuffs
	# 	
	# end
	


	# def test_skill_tree_clean
	#		Reve::API.skill_tree_url = XML_BASE + 'skilltree.xml'
	#		skilltrees = nil
	#		assert_nothing_raised do
	#			skilltrees = @api.skill_tree
	#		end
	#		assert_not_nil @api.last_hash
	#		assert_not_nil @api.cached_until
	#		assert_equal 2, skilltrees.size
	#		skilltrees.each do |skill|
	#			assert_not_nil skill.type_id
	#			assert_not_nil skill.name
	#			assert_not_nil skill.rank
	#			assert_not_nil skill.description
	#			skill.bonuses.each do |bonus|
	#				assert_kind_of Reve::Classes::SkillBonus, bonus
	#			end
	#			skill.attribs.each do |attrib|
	#				assert_kind_of Reve::Classes::RequiredAttribute, attrib
	#			end
	#			skill.required_skills.each do |req|
	#				assert_kind_of Reve::Classes::SkillRequirement, req
	#			end
	#		end
	# end
	# 
	def test_cache_timeout
		api = Wowr::API.new(:character_name => 'Cake', :realm => "Barthilas", :guild_name => "Cake", :debug => true, :caching => true) 
		# api = Wowr::API.new(:character_name => 'Sonny', :realm => "Arena Tournament 1", :locale => 'eu', :debug => true, :caching => false) 
		# api = Wowr::API.new(:realm => "Trollbane", :guild_name => "Rawr", :locale => 'eu', :debug => true, :caching => true) 
		# api.default_cache_timeout = 10

		# char = api.get_character
		
		
		
		
		# path defaults_api.cache_path(url)
		# 
		# if File.exists?(path) ||
		# 		options[:refresh_cache] ||
		# 		(File.mtime(path) < Time.now - @cache_timeout)
		
		
	end
	
	def test_money
		no_gold_silver = Wowr::Classes::Money.new(43)
		assert_equal no_gold_silver.gold, 0
		assert_equal no_gold_silver.silver, 0
		assert_equal no_gold_silver.bronze, 43
		assert_equal no_gold_silver.total, 43
		
		money = Wowr::Classes::Money.new(5552243)
		assert_equal money.gold, 555
		assert_equal money.silver, 22
		assert_equal money.bronze, 43
		assert_equal money.total, 5552243
		
		assert_equal (money + no_gold_silver).total, 5552286
		assert_equal (money - no_gold_silver).total, 5552200
	end
	
	
	def test_assignment
		assert_nothing_raised do
			temp = Wowr::API.search_url
			Wowr::API.search_url = "test"
			Wowr::API.search_url = temp
			
			temp = Wowr::API.cache_directory_path
			Wowr::API.cache_directory_path = "hello/"
			Wowr::API.cache_directory_path = temp
		end
	end

end


# require 'wowr_character_test.rb'
# require 'wowr_guild_test.rb'
# require 'wowr_item_test.rb'
# require 'wowr_arena_team_test.rb'
# require 'wowr_dungeon_test.rb'
