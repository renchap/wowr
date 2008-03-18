# TODO: Item sources - Vendors
# sourceType.vendor
# sourceType.questReward
# sourceType.createdBySpell

# TODO: Split up classes depending on subject?　　Character, Item, Guild, ArenaTeam


# Wowr was written by Ben Humphreys!
# http://wowr.benhumphreys.co.uk/
module Wowr
	module Classes
		
		# Most basic 
		# Composed of an ItemInfo and
		# Needs to be consolidated with ItemInfo and other stuff
		# to be a parent class that they extend?
		class Item
			attr_reader :id, :name, :icon
			alias_method :item_id, :id

			def initialize(elem)
				@id 			= elem[:id].to_i
				@name 		= elem[:name]
				@icon 		= elem[:icon]
			end
		end
		
		
		# Short character info, used in guild lists etc.
		# Note that the way that searches and character listings within guilds works,
		# there can be a variable amount of information filled in within the class.
		# Guild listings and search results contain a smaller amount of information than
		# single queries
		class Character
			attr_reader :name, :level, :url, :rank,
									:klass, :klass_id,
									:gender, :gender_id,
									:race, :race_id,
									:guild, :guild_id, :guild_url,
									:battle_group, :last_login,
									:relevance, :search_rank,
									
									:season_games_played, :season_games_won, :team_rank, :contribution # From ArenaTeam info
			
			def initialize(elem)
				@name	 			= elem[:name]
				@level 			= elem[:level].to_i
				@url 				= elem[:url] || elem[:charUrl]
				@rank 			= elem[:rank].to_i
				
				@klass 			= elem[:class]
				@klass_id		= elem[:classId].to_i
				
				@gender 		= elem[:gender]
				@gender_id 	= elem[:genderId].to_i
				
				@race 			= elem[:race]
				@race_id 		= elem[:raceId].to_i
				
				@guild			= elem[:guild] == "" ? nil : elem[:guild]
				@guild_id		= elem[:guildId].to_i == 0 ? nil : elem[:guildId].to_i
				@guild_url	= elem[:guildUrl] == "" ? nil : elem[:guildUrl]
				
				@battle_group 		= elem[:battleGroup] = "" ? nil : elem[:battleGroup]
				@battle_group_id 	= elem[:battleGroupId].to_i
				
				@relevance 		= elem[:relevance].to_i
				@search_rank 	= elem[:searchRank].to_i
				
				# Incoming string is 2007-02-24 20:33:04.0, parse to datetime
				#@last_login 	= elem[:lastLoginDate] == "" ? nil : DateTime.parse(elem[:lastLoginDate])
				@last_login 	= elem[:lastLoginDate] == "" ? nil : elem[:lastLoginDate]
				
				# From ArenaTeam info, can be blank on normal requests
				#<character battleGroup="" charUrl="r=Draenor&amp;n=Lothaar" class="Paladin" classId="2"
				# contribution="1602" gamesPlayed="10" gamesWon="7" gender="Male" genderId="0"
				# guild="Passion" guildId="36659" guildUrl="r=Draenor&amp;n=Passion&amp;p=1" name="Lothaar"
				# race="Human" raceId="1" seasonGamesPlayed="20" seasonGamesWon="13" teamRank="1"/>
				@season_games_played 	= elem[:seasonGamesPlayed] = "" ? nil : elem[:seasonGamesPlayed].to_i
				@season_games_won 		= elem[:seasonGamesWon] = "" ? nil : elem[:seasonGamesWon].to_i
				@team_rank 						= elem[:teamRank] = "" ? nil : elem[:teamRank].to_i
				@contribution					= elem[:contribution] = "" ? nil : elem[:contribution].to_i
				#@char_url 						= elem[:charUrl]	# TODO: Merge with URL?
			end
		end
		
		
		
		# Full character details
		# uses characterInfo element
		# NEEDS TO EXTEND BASE CHARACTER THING
		class CharacterSheet
			
			# character_info
			attr_reader :name, :level, :char_url, :title,
									:gender, :gender_id,
									:race, :race_id,
			 						:klass, :klass_id,
			 						:faction, :faction_id,
			 						:guild, :guild_url,
			 						:realm,
			 						:battle_group,
									:arena_teams,
									:last_modified
			
			# character_tab
			attr_reader :health, :second_bar,
									:strength, :agility, :stamina, :intellect, :spirit
			alias_method :str, :strength
			alias_method :agi, :agility
			alias_method :sta, :stamina
			alias_method :int, :intellect
			alias_method :spi, :spirit
			
			attr_reader :title
									:melee, :ranged, :spell,
									:defenses, :resistances,
									:talent_spec, :pvp,
									:professions,
									:items,
									:buffs, :debuffs
			
			# It's made up of two parts
			# Don't care about battlegroups yet
			# I don't think I can call stuff from the constructor?
			def initialize(elem)
				character_info(elem%'character')
				character_tab(elem%'characterTab')
			end
			
			# <character
			#  battleGroup="Conviction"
			#  charUrl="r=Genjuros&amp;n=Jonlok"
			#  class="Warlock"
			#  classId="9"
			#  faction="Horde"
			#  factionId="1"
			#  gender="Male"
			#  genderId="0"
			#  guildName=""
			#  lastModified="12 February 2008"
			#  level="41"
			#  name="Jonlok"
			#  prefix="" 
			#  race="Orc"
			#  raceId="2"
			#  realm="Genjuros"
			#  suffix=""/>
			def character_info(elem)
				# basic info
				@name	 			= elem[:name]
				@level 			= elem[:level].to_i
				@char_url 	= elem[:charUrl]
				
				@klass 			= elem[:class]
				@klass_id		= elem[:classId].to_i

				@gender 		= elem[:gender]
				@gender_id 	= elem[:genderId].to_i

				@race 			= elem[:race]
				@race_id 		= elem[:raceId].to_i
				
				@faction 		= elem[:faction]
				@faction_id = elem[:factionId].to_i
				
				@guild			= elem[:guildName] == "" ? nil : elem[:guildName]
				@guild_url	= elem[:guildUrl] == "" ? nil : elem[:guildUrl]
				
				@prefix			= elem[:prefix]
				@suffix			= elem[:suffix]
				
				@realm			= elem[:realm]
				
				@battle_group = elem[:battleGroup]
				
				# format is February 11, 2008
				@last_modified 	= elem[:lastModified] == "" ? nil : DateTime.parse(elem[:lastModified])
				#@last_modified = elem[:lastModified]#.to_time
				
				@arena_teams = []
				(elem/:arenaTeam).each do |arena_team|
					@arena_team << ArenaTeam.new(arena_team)
				end
				
			end
			
			def character_tab(elem)
				
				# <title value=""/>
				@title				= (elem%'title')[:value] == "" ? nil : (elem%'title')[:value]
				#@known_titles = <knownTitles/>
				
				@health 		= (elem%'characterBars'%'health')[:effective].to_i
				@second_bar = SecondBar.new(elem%'characterBars'%'secondBar')
				
				# base stats
				@strength 	= Strength.new(elem%'baseStats'%'strength')
				@agility 		= Agility.new(elem%'baseStats'%'agility')
				@stamina 		= Stamina.new(elem%'baseStats'%'stamina')
				@intellect 	= Intellect.new(elem%'baseStats'%'intellect')
				@spirit 		= Spirit.new(elem%'baseStats'%'spirit')
				
				# damage stuff
				@melee 		= Melee.new(elem%'melee')
				@ranged 	= Ranged.new(elem%'ranged')
				@spell 		= Spell.new(elem.at(' > spell'))	# TODO: hacky?
				@defenses = Defenses.new(elem%'defenses')
				
				# TODO: Massive problem, doesn't fill in resistances for some reason
				resist_types = ['arcane', 'fire', 'frost', 'holy', 'nature', 'shadow']
				@resistances = {}
				resist_types.each do |res|
					@resistances[res] = Resistance.new(elem%'resistances'%res)
				end
				
				@talent_spec = TalentSpec.new(elem%'talentSpec')
				
				@pvp = Pvp.new(elem%'pvp')
								
				@professions = []
				(elem%'professions'/:skill).each do |skill|
					@professions << Profession.new(skill)
				end
				
				@items = []
				(elem%'items'/:item).each do |item|
					@items << EquippedItem.new(item)
				end
				
				@buffs = []
				(elem%'buffs'/:spell).each do |buff|
					@buffs << Buff.new(buff)
				end
				
				@debuffs = []
				(elem%'debuffs'/:spell).each do |debuff|
					@debuffs << Buff.new(debuff)
				end
			end
		end
		
		
		
		# Second stat bar, depends on character class
		class SecondBar
			attr_reader :effective, :casting, :not_casting, :type
			
			def initialize(elem)
				@effective 		= elem[:effective].to_i
				@casting 			= elem[:casting].to_i == -1 ? nil : elem[:casting].to_i
				@not_casting 	= elem[:notCasting].to_i == -1 ? nil : elem[:notCasting].to_i
				@type 				= elem[:type]
			end
		end
		
		
		
		class BaseStat	# abstract?
			attr_reader :base, :effective
		end
		
		class Strength < BaseStat
			attr_reader :attack, :block
			def initialize(elem)
				@base				= elem['base'].to_i
				@effective 	= elem['effective'].to_i
				@attack 		= elem['attack'].to_i
				@block 			= elem['block'].to_i == -1 ? nil : elem['block'].to_i
			end
		end
		
		class Agility < BaseStat
			attr_reader :armor, :attack, :crit_hit_percent
			def initialize(elem)
				@base	 		 				= elem[:base].to_i
				@effective 				= elem[:effective].to_i
				@armor 		 				= elem[:armor].to_i
				@attack 					= elem[:attack].to_i == -1 ? nil : elem[:attack].to_i
				@crit_hit_percent = elem[:critHitPercent].to_f
			end
		end
		
		class Stamina < BaseStat
			attr_reader :health, :pet_bonus
			def initialize(elem)
				@base 			= elem[:base].to_i
				@effective 	= elem[:effective].to_i
				@health 		= elem[:health].to_i
				@pet_bonus 	= elem[:petBonus].to_i == -1 ? nil : elem[:petBonus].to_i
			end
		end
		
		class Intellect < BaseStat
			attr_reader :mana, :crit_hit_percent, :pet_bonus
			def initialize(elem)
				@base	 						= elem[:base].to_i
				@effective 				= elem[:effective].to_i
				@mana 						= elem[:mana].to_i
				@crit_hit_percent = elem[:critHitPercent].to_f
				@pet_bonus 				= elem[:petBonus].to_i == -1 ? nil : elem[:petBonus].to_i
			end
		end
		
		class Spirit < BaseStat
			attr_reader :health_regen, :mana_regen
			def initialize(elem)
				@base	 				= elem[:base].to_i
				@effective 		= elem[:effective].to_i
				@health_regen = elem[:healthRegen].to_i
				@mana_regen 	= elem[:manaRegen].to_i
			end
		end
		
		class Armor < BaseStat
			attr_reader :percent, :pet_bonus
			def initialize(elem)
				@base 			= elem[:base].to_i
				@effective 	= elem[:effective].to_i
				@percent 		= elem[:percent].to_f
				@pet_bonus 	= elem[:petBonus].to_i == -1 ? nil : elem[:petBonus].to_i
			end
		end
		
		
		
		
		
		# <melee>
		# 	<mainHandDamage dps="65.6" max="149" min="60" percent="0" speed="1.60"/>
		# 	<offHandDamage dps="0.0" max="0" min="0" percent="0" speed="2.00"/>
		# 	<mainHandSpeed hastePercent="0.00" hasteRating="0" value="1.60"/>
		# 	<offHandSpeed hastePercent="0.00" hasteRating="0" value="2.00"/>
		# 	<power base="338" effective="338" increasedDps="24.0"/>
		# 	<hitRating increasedHitPercent="0.00" value="0"/>
		# 	<critChance percent="4.16" plusPercent="0.00" rating="0"/>
		# 	<expertise additional="0" percent="0.00" rating="0" value="0"/>
		# </melee>
		class Melee
			attr_reader :main_hand_skill, :off_hand_skill,
									:main_hand_damage, :off_hand_damage,
									:main_hand_speed, :off_hand_speed,
									:speed, :hit_rating, :crit_chance
									:expertise

			def initialize(elem)
				# TODO: Do these not exist anymore?
				@main_hand_skill 	= WeaponSkill.new(elem%'mainHandWeaponSkill') if (elem%'mainHandWeaponSkill')
				@off_hand_skill 	= WeaponSkill.new(elem%'offHandWeaponSkill') if (elem%'offHandWeaponSkill')
				
				@main_hand_damage = WeaponDamage.new(elem%'mainHandDamage')
				@off_hand_damage 	= WeaponDamage.new(elem%'offHandDamage')
				
				@main_hand_speed 	= WeaponSpeed.new(elem%'mainHandSpeed')
				@off_hand_speed 	= WeaponSpeed.new(elem%'offHandSpeed')
				
				@power 						= WeaponPower.new(elem%'power')
				@hit_rating 			= WeaponHitRating.new(elem%'hitRating')
				@crit_chance 			= WeaponCritChance.new(elem%'critChance')
				
				@expertise 				= WeaponExpertise.new(elem'expertise')
			end
		end

		# <ranged>
		# 	<weaponSkill rating="0" value="-1"/>
		# 	<damage dps="0.0" max="0" min="0" percent="0" speed="0.00"/>
		# 	<speed hastePercent="0.00" hasteRating="0" value="0.00"/>
		# 	<power base="57" effective="57" increasedDps="4.0" petAttack="-1.00" petSpell="-1.00"/>
		# 	<hitRating increasedHitPercent="0.00" value="0"/>
		# 	<critChance percent="0.92" plusPercent="0.00" rating="0"/>
		# </ranged>
		class Ranged
			attr_reader :weapon_skill, :damage, :speed, :power,
									:hit_rating, :crit_chance

			def initialize(elem)
				@weapon_skill = WeaponSkill.new(elem%'weaponSkill')
				@damage 			= WeaponDamage.new(elem%'damage')
				@speed 				= WeaponSpeed.new(elem%'speed')
				@power 				= WeaponPower.new(elem%'power')
				@hit_rating 	= WeaponHitRating.new(elem%'hitRating')
				@crit_chance 	= WeaponCritChance.new(elem%'critChance')
			end
		end
			
		class WeaponSkill
			attr_reader :rating, :value
			
			def initialize(elem)
				@value 	= elem[:value].to_i == -1 ? nil : elem[:value].to_i
				@rating = elem[:rating].to_i
			end
		end
		
		class WeaponDamage
			attr_reader :dps, :max, :min, :percent, :speed
			
			def initialize(elem)
				@dps 			= elem[:dps].to_f
				@max 			= elem[:max].to_i
				@min 			= elem[:min].to_i
				@percent 	= elem[:percent].to_f
				@speed 	= elem[:speed].to_f
			end
		end
		
		class WeaponSpeed
			attr_reader :haste_percent, :haste_rating, :value
			
			def initialize(elem)
				@haste_percent 	= elem[:hastePercent].to_f
				@haste_rating 	= elem[:hasteRating].to_f
				@value 				= elem[:value].to_f
			end
		end
		
		class WeaponPower
			attr_reader :base, :effective, :increased_dps, :pet_attack, :pet_spell
			
			def initialize(elem)
				@base 					= elem[:base].to_i
				@haste_rating 	= elem[:effective].to_i
				@increased_dps 	= elem[:increasedDps].to_f
				@pet_attack 		= (elem[:petAttack].to_f == -1 ? nil : elem[:petAttack].to_f)
				@pet_spell 			= (elem[:petSpell].to_f == -1 ? nil : elem[:petSpell].to_f)					
			end
		end
		
		class WeaponHitRating
			attr_reader :increased_hit_percent, :value
			
			def initialize(elem)
				@increased_hit_percent 	= elem[:increasedHitPercent].to_f
				@value 									= elem[:value].to_f
			end
		end
		
		class WeaponCritChance
			attr_reader :percent, :plus_percent, :rating
			
			def initialize(elem)
				@percent 			= elem[:percent].to_f
				@plus_percent = elem[:plusPercent].to_f
				@rating 			= elem[:rating].to_i
			end
		end
		
		# <expertise additional="0" percent="0.00" rating="0" value="0"/>
		class WeaponExpertise
			attr_reader :additional, :percent, :rating, :value
			
			def initialize(elem)
				@additional	= elem[:percent].to_i
				@percent 		= elem[:percent].to_f
				@rating 		= elem[:rating].to_i
				@value			= elem[:value].to_i
			end
		end
		
		
		# Decided to do funky stuff to the XML to make it more useful.
		# instead of having two seperate lists of bonusDamage and critChance
		# merged it into one set of objects for each thing
		class Spell
			attr_reader :arcane, :fire, :frost, :holy, :nature, :shadow,
									:hit_rating, :bonus_healing, :penetration, :mana_regen
			
			def initialize(elem)
				@arcane = SpellDamage.new(elem%'bonusDamage'%'arcane', elem%'critChance'%'arcane')
				@fire   = SpellDamage.new(elem%'bonusDamage'%'fire', elem%'critChance'%'fire')
				@frost  = SpellDamage.new(elem%'bonusDamage'%'frost', elem%'critChance'%'frost')
				@holy   = SpellDamage.new(elem%'bonusDamage'%'holy', elem%'critChance'%'holy')
				@nature = SpellDamage.new(elem%'bonusDamage'%'nature', elem%'critChance'%'nature')
				@shadow = SpellDamage.new(elem%'bonusDamage'%'shadow', elem%'critChance'%'shadow')

				@bonus_healing 	= (elem%'bonusHealing')[:value].to_i # is this right??
				@penetration 		= (elem%'penetration')[:value].to_i
				@hit_rating 		= WeaponHitRating.new(elem%'hitRating')
				@mana_regen 		= ManaRegen.new(elem%'manaRegen')
				
				# elements = %w[arcane fire frost holy nature shadow]
				# elements.each do |element|
				# 	# TODO: is this a good idea?
				# 	#instance_variable_set("@#{element}", foo) #??
				# 	#eval("@#{element} = SpellDamage.new(elem[:bonusDamage][element][:value], elem[:critChance][element][:percent]).to_f)")
				# 	# eval("@#{element} = SpellDamage.new((elem%'bonusDamage'%element)[:value].to_i,
				# 	# 																						(elem%'critChance'%element)[:percent].to_f)")
				# end
			end
		end
		
		class SpellDamage
			attr_reader :value, :crit_chance_percent
			alias_method :percent, :crit_chance_percent
			
			def initialize(bonusDamage_elem, critChance_elem)
				@value 		= bonusDamage_elem[:value].to_i
				@crit_chance_percent	= critChance_elem[:percent].to_f
			end
		end
		
		class ManaRegen
			attr_reader :casting, :not_casting
			
			def initialize(elem)
				@casting 			= elem[:casting].to_f
				@not_casting 	= elem[:notCasting].to_f
			end
		end
		
		class PetBonus
			attr_reader :attack, :damage, :from_Type
			
			def initialize(elem)
				@attack 		= elem[:attack].to_i == -1 ? nil : elem[:attack].to_i
				@damage 		= elem[:damage].to_i == -1 ? nil : elem[:damage].to_i
				@from_type 	= elem[:fromType] if elem[:fromType]
			end
		end
		
		
		
		class Defenses
			attr_reader :armor, :defense, :dodge, :parry, :block, :resilience
			
			def initialize(elem)
				@armor 			= Armor.new(elem%'armor')
				@defense 		= Defense.new(elem%'defense')
				@dodge 			= DodgeParryBlock.new(elem%'dodge')
				@parry 			= DodgeParryBlock.new(elem%'parry')
				@block 			= DodgeParryBlock.new(elem%'block')
				@resilience = Resilience.new(elem%'resilience')
			end
		end
		
		class Armor
			attr_reader :base, :effective, :percent, :pet_bonus
			
			def initialize(elem)
				@base 			= elem[:base].to_i
				@effective 	= elem[:effective].to_i
				@percent 		= elem[:percent].to_f
				@pet_bonus 	= elem[:petBonus].to_i == -1 ? nil : elem[:petBonus].to_i
			end
		end
		
		class Defense
			attr_reader :value, :increase_percent, :decrease_percent, :plus_defense, :rating
			
			def initialize(elem)
				@value 						= elem[:value].to_i
				@increase_percent = elem[:increasePercent].to_f
				@decrease_percent = elem[:decreasePercent].to_f
				@plus_defense 		= elem[:plusDefense].to_i
				@rating 					= elem[:rating].to_i
			end
		end
		
		class DodgeParryBlock
			attr_reader :percent, :increase_percent, :rating
			
			def initialize(elem)
				@percent 					= elem[:percent].to_f
				@increase_percent = elem[:increasePercent].to_f
				@rating 					= elem[:rating].to_i
			end
		end
		
		class Resilience
			attr_reader :damage_percent, :hit_percent, :value
			
			def initialize(elem)
				@damage_percent = elem[:damagePercent].to_f
				@hit_percent 		= elem[:hitPercent].to_f
				@value 					= elem[:value].to_f
			end
		end
		
		
		
		class Resistance
			attr_reader :value, :pet_bonus
			
			def initialize(elem)
				@value 			= elem[:value].to_i
				@pet_bonus 	= elem[:petBonus].to_i == -1 ? nil : elem[:petBonus].to_i
			end
		end
		
		
		# Note the list of talent trees starts at 1. This is quirky, but that's what's used in the XML
		class TalentSpec
			attr_reader :trees

			def initialize(elem)
				@trees = []
				@trees[1] = elem[:treeOne].to_i
				@trees[2] = elem[:treeTwo].to_i
				@trees[3] = elem[:treeThree].to_i
			end
		end
		
				
		# Player-versus-player data
		class Pvp
			attr_reader :lifetime_honorable_kills, :arena_currency
			
			def initialize(elem)
				@lifetime_honorable_kills = (elem%'lifetimehonorablekills')[:value].to_i
				@arena_currency 					= (elem%'arenacurrency')[:value].to_i
			end
		end
		
		
		# A buff 
		class Buff
			attr_reader :name, :effect, :icon
			
			def initialize(elem)
				@name 	= elem[:name]
				@effect = elem[:effect]
				@icon 	= elem[:icon]
			end
		end
		
		
		# A player's profession, players can only have 2 max
		class Profession
			attr_reader :key, :name, :max, :value
			
			def initialize(elem)
				@key		= elem[:key]
				@name		= elem[:name]
				@value	= elem[:value].to_i
				@max		= elem[:max].to_i
			end
		end
		
		
		# An item equipped to a player
		class EquippedItem < Item
			attr_reader :durability, :max_durability, #:id, :item_id, :icon,
									:gems, :permanent_enchant,
									:random_properties_id, :seed, :slot
			
			def initialize(elem)
				super(elem)
				#@id										= elem[:id].to_i
				#@icon									= elem[:icon]
				@durability						= elem[:durability].to_i
				@max_durability				= elem[:maxDurability].to_i
				@gems = []
				@gems[0]							= elem[:gem0Id].to_i == 0 ? nil : elem[:gem0Id].to_i
				@gems[1]							= elem[:gem1Id].to_i == 0 ? nil : elem[:gem1Id].to_i
				@gems[2]							= elem[:gem2Id].to_i == 0 ? nil : elem[:gem2Id].to_i
				@permanent_enchant		= elem[:permanentEnchant].to_i
				@random_properties_id = elem[:randomPropertiesId] == 0 ? nil : elem[:randomPropertiesId].to_i
				@seed									= elem[:seed].to_i # not sure if seed is so big it's overloading
				@slot									= elem[:slot].to_i
			end
		end

		
		# A player guild containing members
		# note not all of these will be filled out, depending on how the data is found		
		class Guild
			attr_reader :name, :url, :realm, :realm_url, :battle_group,
									:roster_url, :stats_url, :stats_url_escape,
									:faction, :faction_id,
									:members, :member_count

			def initialize(elem)
				if (elem%'guildKey')
					guild = (elem%'guildKey')
				else
					guild = elem
				end
				
				@name					= guild[:name]
				@name_url			= guild[:nameUrl]
				@url					= guild[:url]
				@realm				= guild[:realm]
				@realm_url		= guild[:realmUrl]
				@battle_group = guild[:battleGroup]
				@faction			= guild[:faction]
				@faction_id		= guild[:factionId].to_i
				
				# some shortened versions
				if (elem%'guildInfo')
					@member_count = (elem%'guildInfo'%'guild'%'members')[:memberCount].to_i || nil
				
					@members = []
					(elem%'guildInfo'%'guild'%'members'/:character).each do |char|
						members << Character.new(char)
					end
				end
			end
		end
		
		
		# General skill category
		# eg Weapon Skills, Languages
		class SkillCategory
			attr_reader :key, :name, :skills
			
			def initialize(elem)
				@key 	= elem[:key]
				@name = elem[:name]
				
				@skills = []
				(elem/:skill).each do |skill|
					@skills << Skill.new(skill)
				end
			end
		end
		
		# 
		# eg Daggers, Riding, Fishing 
		class Skill
			attr_reader :key, :name, :value, :max
			
			def initialize(elem)
				@key 		= elem[:key]
				@name 	= elem[:name]
				@value 	= elem[:value]
				@max 		= elem[:max]
			end
		end
		
		
		
		
		# Larger group of factions
		# eg Alliance, Shattrath City, Steamwheedle Cartel
		# character-reputation.xml
		class FactionCategory
			attr_reader :key, :name, :factions
			
			def initialize(elem)
				@key 	= elem[:key]
				@name = elem[:name]
				
				@factions = []
				(elem/:faction).each do |faction|
					@factions << Faction.new(faction)
				end
			end
		end
		
		# Smaller NPC faction that is part of a FactionCategory
		# eg Darnassus, Argent Dawn
		class Faction
			attr_reader :key, :name, :reputation
			
			def initialize(elem)
				@key 				= elem[:key]
				@name 			= elem[:name]
				@reputation = elem[:reputation].to_i
			end
		end
		
		
		
		
		# Provides detailed item information
		# Note that the itemtooltip XML just returns an empty document when the item 
		# can't be found.
		class ItemTooltip < Item
			attr_reader :desc, :overall_quality_id, :bonding, :max_count, #:id, :name, :icon, 
									:class_id, :bonuses, :item_source,
									:bonuses, :resistances,
									:required_level,
									:allowable_classes,
									:armor, :durability,
									:sockets, :socket_match_enchant,
									:gem_properties
			alias_method :description, :desc

			def initialize(elem)
				@id									= (elem%'id').html.to_i
				@name								= (elem%'name').html
				@icon								= (elem%'icon').html
				@desc								= (elem%'desc').html if (elem%'desc')
				@overall_quality_id	= (elem%'overallQualityId').html.to_i
				@bonding						= (elem%'bonding').html.to_i
				@stackable					= (elem%'stackable').html.to_i if (elem%'stackable')
				@max_count					= (elem%'maxCount').html.to_i if (elem%'maxCount')
				@class_id						= (elem%'classId').html.to_i
				@required_level			= (elem%'requiredLevel').html.to_i if (elem%'requiredLevel')
				
				@equipData					= ItemEquipData.new(elem%'equipData')
				
				# TODO: This appears to be a plain string at the moment
				#<gemProperties>+26 Healing +9 Spell Damage and 2% Reduced Threat</gemProperties>
				@gem_properties			= (elem%'gemProperties').html if (elem%'gemProperties')
				
				# not all items have damage data
				@damage							= ItemDamageData.new(elem%'damageData') if !(elem%'damageData').html.empty?

				
				# TODO: Test socket data with a variety of items
				# TODO: replace with socket Class?
				if (elem%'socketData')
					@sockets = []
					(elem%'socketData'/:socket).each do |socket|
						@sockets << socket[:color]
					end
					
					@socket_match_enchant = (elem%'socketData'%'socketMatchEnchant')
				end
				
				
				# When there is no data, stats are not present in @bonuses
				# TODO: When there is no stats at all, @bonuses shouldn't be set
				@bonuses = {}
				
				bonus_stats = {
					:strength => :bonusStrength,
					:agility => :bonusAgility,
					:stamina => :bonusStamina,
					:intellect => :bonusIntellect,
					:spirit => :bonusSpirit
				}
				bonus_stats.each do |stat, xml_elem|
					@bonuses[stat] = test_stat(elem/xml_elem) if test_stat(elem/xml_elem)
				end
				
				# Resistances
				@resistances = {}
				
				resist_stats = {
					:arcane => :arcaneResist,
					:fire => :fireResist,
					:frost => :frostResist,
					:holy => :holyResist,
					:nature => :natureResist,
					:shadow => :shadowResist
				}
				resist_stats.each do |stat, xml_elem|
					@resistances[stat] = test_stat(elem/xml_elem) if test_stat(elem/xml_elem)
				end
				
				
				if (elem%'allowableClasses')
					@allowable_classes = []
					(elem%'allowableClasses'/:class).each do |klass|
						@allowable_classes << klass.html
					end
				end
				
				# NOTE not representing armor bonus
				@armor			= (elem%'armor').html.to_i 						if (elem%'armor')
				
				# NOTE not representing max
				@durability	= (elem%'durability')[:current].to_i	if (elem%'durability')
				
				if (elem%'spellData')
					@spells = []
					(elem%'spellData'/:spell).each do |spell|
						@spells << ItemSpell.new(spell)
					end
				end
				
				@setData = ItemSetData.new(elem%'setData') if (elem%'setData')
				
				# @item_sources = []
				# (elem/:itemSource).each do |source|
				# 	@item_sources << ItemSource.new(source)
				# end
				@item_source = ItemSource.new(elem%'itemSource') if (elem%'itemSource')	 # TODO: More than once source?
			end
			
			private
			def test_stat(elem)
				if elem
					if !elem.html.empty?
						return elem.html.to_i
					end
				end
				return nil
			end
		end
		
		class ItemEquipData
			attr_reader :inventory_type, :subclass_name, :container_slots

			def initialize(elem)
				@inventory_type = (elem%'inventoryType').html.to_i
				@subclass_name = (elem%'subclassName').html if (elem%'subclassName')
				@container_slots = (elem%'containerSlots').html.to_i if (elem%'containerSlots') # for baggies
			end
		end
		
		class ItemSetData
			attr_reader :name, :items, :set_bonuses
			
			def initialize(elem)
				@name = elem[:name]
				
				@items = []
				(elem/:item).each do |item|
					@items << item[:name]
				end
				
				@set_bonuses = []
				(elem/:setBonus).each do |bonus|
					@set_bonuses << ItemSetBonus.new(bonus)
				end
			end
		end
		
		class ItemSetBonus
			attr_reader :threshold, :description
			alias_method :desc, :description
			
			def initialize(elem)
				@threshold = elem[:threshold].to_i
				@description = elem[:desc]
			end
		end

		class ItemSpell
			attr_reader :trigger, :description
			alias_method :desc, :description

			def initialize(elem)
				@trigger = (elem%'trigger').html.to_i
				@description = (elem%'desc').html
			end
		end

		class ItemDamageData
			attr_reader :type, :min, :max, :speed, :dps

			def initialize(elem)
				@type 	= (elem%'damage'%'type').html.to_i
				@min 		= (elem%'damage'%'min').html.to_i
				@max 		= (elem%'damage'%'max').html.to_i
				@speed 	= (elem%'speed').html.to_i
				@dps 		= (elem%'dps').html.to_f
			end
		end

		class ItemSource
			attr_reader :value,
									:area_id, :area_name,
									:creature_id, :creature_name,
									:difficulty, :drop_rate

			def initialize(elem)
				@value 					= elem[:value]
				@area_id 				= elem[:areaId].to_i 			if elem[:areaId]
				@area_name 			= elem[:areaName]					if elem[:areaName]
				@creature_id 		= elem[:creatureId].to_i	if elem[:creatureId]
				@creature_name 	= elem[:creatureName]			if elem[:creatureName]
				@difficulty 		= elem[:difficulty]				if elem[:difficulty]
				@drop_rate 			= elem[:dropRate].to_i		if elem[:dropRate]
				@required_level	= elem[:reqLvl].to_i			if elem[:reqLvl]
			end
		end
		
		

		# A really basic item type returned by searches
		class SearchItem < Item
			attr_reader :url, :rarity,
									:source, :item_level, :relevance
			alias_method :level, :item_level

			def initialize(elem)
				super(elem)
				@rarity			= elem[:rarity].to_i
				@url				= elem[:url]

				@item_level	= elem.at("filter[@name='itemLevel']")[:value].to_i
				@source			= elem.at("filter[@name='source']")[:value]
				@relevance	= elem.at("filter[@name='relevance']")[:value].to_i
			end
		end
		
		
		
		
		# uses item-info.xml
		class ItemInfo < Item
			attr_reader :icon, :id, :level, :name, :quality, :type,
									:cost, :disenchants, :disenchant_skill_rank, :vendors,
									:plans_for
			
			def initialize(elem)
				@id 			= elem[:id].to_i
				@level 		= elem[:level].to_i
				@name 		= elem[:name]
				@icon 		= elem[:icon]
				@quality 	= elem[:quality].to_i
				@type 		= elem[:type]
			
				# Cost can be in gold, or tokens
				@cost = ItemCost.new(elem%'cost') if (elem%'cost')
				
				
				
				# is costs really an array?
				#@costs 		= []
				#(elem/:cost).each do |cost|
				#	@costs << ItemCost.new(cost)
				#end
			
				if (elem%'disenchantLoot')
					@disenchant_skill_rank = (elem%'disenchantLoot')[:requiredSkillRank].to_i 
			
					@disenchant_items = []
					(elem%'disenchantLoot'/:item).each do |item|
						@disenchant_items << DisenchantItem.new(item)
					end
				end
				
				if (elem%'objectiveOfQuests')
					@objective_of_quests = []
					(elem%'objectiveOfQuests'/:quest).each do |quest|
						@objective_of_quests << ItemQuest.new(quest)
					end
				end
				
				if (elem%'rewardFromQuests')
					@reward_from_quests = []
					(elem%'rewardFromQuests'/:quest).each do |quest|
						@reward_from_quests << ItemQuest.new(quest)
					end
				end

				if (elem%'vendors')
					@vendors = []
					(elem%'vendors'/:creature).each do |vendor|
						@vendors << ItemVendor.new(vendor)
					end
				end
				
				if (elem%'dropCreatures')
					@drop_creatures = []
					(elem%'dropCreatures'/:creature).each do |creature|
						@drop_creatures << ItemDropCreature.new(creature)
					end
				end
				
				if (elem%'plansFor')
					@plans_for = []
					(elem%'plansFor'/:spell).each do |plan|
						@plans_for << ItemPlansFor.new(plan)
					end
				end
				
				if (elem%'createdBy')
					@created_by = []
					(elem%'createdBy'/:spell).each do |c|
						@created_by << ItemCreatedBy.new(c)
					end
				end
			end
		end
		
    # <rewardFromQuests>
    #   <quest name="Justice Dispensed" level="39" reqMinLevel="30" id="11206" area="Dustwallow Marsh" suggestedPartySize="0"></quest>
    #   <quest name="Peace at Last" level="39" reqMinLevel="30" id="11152" area="Dustwallow Marsh" suggestedPartySize="0"></quest>
    # </rewardFromQuests>
		# TODO: Rename
		class ItemQuest
			attr_reader :name, :id, :level, :min_level, :area, :suggested_party_size
			
			def initialize(elem)
				@name 			= elem[:name]
				@id 				= elem[:id].to_i
				@level 			= elem[:level].to_i
				@min_level 	= elem[:min_level].to_i
				@area 			= elem[:area]
				@suggested_party_size = elem[:suggested_party_size].to_i
			end
		end
		
		
		
		# Creatures that drop the item
		# <creature name="Giant Marsh Frog" minLevel="1" type="Critter" maxLevel="1" dropRate="6" id="23979" classification="0" area="Dustwallow Marsh"></creature>
		# <creature name="Nalorakk" minLevel="73" title="Bear Avatar" url="fl[source]=dungeon&amp;fl[difficulty]=normal&amp;fl[boss]=23576" type="Humanoid" maxLevel="73" dropRate="2" id="23576" classification="3" areaUrl="fl[source]=dungeon&amp;fl[boss]=all&amp;fl[difficulty]=normal&amp;fl[dungeon]=3805" area="Zul'Aman"></creature>
		class ItemDropCreature
			attr_reader :name, :id, :type, :min_level, :max_level, :drop_rate, :classification, :area
			
			def initialize(elem)
				@name 					= elem[:name]
				@id 						= elem[:id].to_i
				@min_level 			= elem[:minLevel].to_i
				@max_level 			= elem[:maxLevel].to_i
				@drop_rate 			= elem[:dropRate].to_i
				@classification = elem[:classification].to_i
				@area 					= elem[:area]
				
				# optional boss stuff
				@title 		= elem[:title]		if elem[:title] # TODO: not nil when no property?
				@url			= elem[:url]			if elem[:url]
				@type			= elem[:type]			if elem[:type] # Humanoid etc.
				@area_url = elem[:areaUrl]	if elem[:areaUrl]
			end	
		end
		 
		# Cost can be gold or a set of required tokens
		# See ItemCostToken
		# <cost sellPrice="280" buyPrice="5600"></cost>
		# <cost>
		# 	<token icon="spell_holy_championsbond" id="29434" count="60"></token>
		# </cost>
		class ItemCost
			attr_reader :buy_price, :sell_price, :tokens
			
			def initialize(elem)
				@buy_price 	= elem[:buyPrice].to_i	if elem[:buyPrice]
				@sell_price	= elem[:sellPrice].to_i	if elem[:sellPrice]
				
				if (elem%'token')
					@tokens = []
					(elem/:token).each do |token|
						@tokens << ItemCostToken.new(token)
					end
				end
			end
		end
		
		# <token icon="spell_holy_championsbond" id="29434" count="60"></token>
		class ItemCostToken
			attr_reader :id, :icon, :count
			
			def initialize(elem)
				@id = elem[:id].to_i
				@icon = elem[:icon]
				@count = elem[:count].to_i
			end
		end
		
		# <item name="Void Crystal" minCount="1" maxCount="2" icon="inv_enchant_voidcrystal" type="Enchanting" level="70" dropRate="6" id="22450" quality="4"></item>
		class DisenchantItem
			attr_reader :name, :id, :icon, :level, :type, :drop_rate, :min_count, :max_count, :quality
			
			def initialize(elem)
				@name 			= elem[:name]
				@id 				= elem[:id].to_i
				@icon 			= elem[:icon]
				@level 			= elem[:level].to_i
				@type 			= elem[:type]
				@drop_rate 	= elem[:dropRate].to_i
				@min_count 	= elem[:minCount].to_i
				@max_count 	= elem[:maxCount].to_i
				@quality 		= elem[:quality].to_i
			end
		end
		
		class ItemVendor
			attr_reader :id, :name, :title, :type,
									:area, :classification, :max_level, :min_level
			
			def initialize(elem)
				@id 						= elem[:id].to_i
				@name 					= elem[:name]
				@title 					= elem[:title]
				@type 					= elem[:type]
				@area 					= elem[:area]
				@classification = elem[:classification].to_i
				@max_level 			= elem[:maxLevel].to_i
				@min_level 			= elem[:minLevel].to_i
			end
		end
		
		

		
		# TODO rename
		# There is some sort of opposite relationship between PlansFor and CreatedBy
		class ItemCreation
			attr_reader :name, :id, :icon,
									:item, :reagents
			
			def initialize(elem)
				@name = elem[:name]
				@id = elem[:id].to_i
				@icon = elem[:icon]
				
				# not all items have reagents, some are just spells
				if (elem%'reagent')
					@reagents = []
					(elem/:reagent).each do |reagent|
						@reagents << Reagent.new(reagent)
					end
				end
			end
		end
		
		
		# <plansFor>
		#   <spell name="Shadowprowler's Chestguard" icon="trade_leatherworking" id="42731">
		#     <item name="Shadowprowler's Chestguard" icon="inv_chest_plate11" type="Leather" level="105" id="33204" quality="4"></item>
		#     <reagent name="Heavy Knothide Leather" icon="inv_misc_leatherscrap_11" id="23793" count="10"></reagent>
		#     <reagent name="Bolt of Soulcloth" icon="inv_fabric_soulcloth_bolt" id="21844" count="16"></reagent>
		#     <reagent name="Primal Earth" icon="inv_elemental_primal_earth" id="22452" count="12"></reagent>
		#     <reagent name="Primal Shadow" icon="inv_elemental_primal_shadow" id="22456" count="12"></reagent>
		#     <reagent name="Primal Nether" icon="inv_elemental_primal_nether" id="23572" count="2"></reagent>
		#   </spell>
		# </plansFor>
		class ItemPlansFor < ItemCreation
			def initialize(elem)
				super(elem)
				# TODO: Multiple items?
				@item = CreatedItem.new(elem%'item')  if (elem%'item')
			end			
		end
		
		# <createdBy>
		# 	<spell name="Bracing Earthstorm Diamond" icon="temp" id="32867">
		# 		<item requiredSkill="Jewelcrafting" name="Design: Bracing Earthstorm Diamond" icon="inv_scroll_03" type="Jewelcrafting" level="73" id="25903" requiredSkillRank="365" quality="1"></item>
		# 		<reagent name="Earthstorm Diamond" icon="inv_misc_gem_diamond_04" id="25867" count="1"></reagent>
		# 	</spell>
		# </createdBy>
		class ItemCreatedBy < ItemCreation
			def initialize(elem)
				super(elem)
				# TODO: Multiple items?
				@item = PlanItem.new(elem%'item') if (elem%'item')
			end
		end
		
		# TODO: Might be better to reuse an existing Item class?
		# <item name="Shadowprowler's Chestguard" icon="inv_chest_plate11" type="Leather" level="105" id="33204" quality="4"></item>
		class CreatedItem < Item
			attr_reader :type, :level, :quality
			
			def initialize(elem)
				super(elem)
				@type = elem[:type]
				@level = elem[:level].to_i
				@quality = elem[:quality].to_i
			end
		end
		
		# TODO: Might be better to reuse an existing Item class?
		# <item requiredSkill="Jewelcrafting" name="Design: Bracing Earthstorm Diamond" icon="inv_scroll_03" type="Jewelcrafting" level="73" id="25903" requiredSkillRank="365" quality="1"></item>
		class PlanItem < Item
			attr_reader :required_skill, :type, :required_skill_rank, :level, :quality
			
			def initialize(elem)
				super(elem)
				@type = elem[:type]
				@level = elem[:level].to_i
				@quality = elem[:quality].to_i
				@required_skill = elem[:requiredSkill]
				@required_skill_rank = elem[:requiredSkillRank].to_i
			end
		end
			
		class Reagent
			attr_reader :id, :name, :icon, :count
			
			def initialize(elem)
				@id = elem[:id].to_i
				@name = elem[:name]
				@icon = elem[:icon]
				@count = elem[:count].to_i
			end
		end
		
		

		# A group of individuals
		# Note that search results don't contain the members
		# <arenaTeams>
		# 	<arenaTeam battleGroup="Blackout" faction="Alliance" factionId="0" gamesPlayed="10" gamesWon="7" lastSeasonRanking="0" name="SØPPERBIL" ranking="8721" rating="1610" realm="Draenor" realmUrl="b=Blackout&amp;r=Draenor&amp;ts=2&amp;t=S%C3%98PPERBIL&amp;ff=realm&amp;fv=Draenor&amp;select=S%C3%98PPERBIL" seasonGamesPlayed="49" seasonGamesWon="28" size="2" url="r=Draenor&amp;ts=2&amp;t=S%C3%98PPERBIL&amp;select=S%C3%98PPERBIL">
		# 		<emblem background="ff2034cc" borderColor="ff14a30c" borderStyle="1" iconColor="ff1d800a" iconStyle="95"/>
		# 		<members>
		# 			<character battleGroup="" charUrl="r=Draenor&amp;n=Arussil" class="Rogue" classId="4" contribution="1613" gamesPlayed="10" gamesWon="7" gender="Male" genderId="0" guild="Adept" guildId="38253" guildUrl="r=Draenor&amp;n=Adept&amp;p=1" name="Arussil" race="Night Elf" raceId="4" seasonGamesPlayed="48" seasonGamesWon="28" teamRank="0"/>
		# 			<character battleGroup="" charUrl="r=Draenor&amp;n=Cake" class="Shaman" classId="7" contribution="1516" gamesPlayed="0" gamesWon="0" gender="Male" genderId="0" guild="Adept" guildId="38253" guildUrl="r=Draenor&amp;n=Adept&amp;p=1" name="Cake" race="Draenei" raceId="11" seasonGamesPlayed="1" seasonGamesWon="1" teamRank="1"/>
		# 
		# 			<character battleGroup="" charUrl="r=Draenor&amp;n=Efes" class="Druid" classId="11" contribution="1508" gamesPlayed="0" gamesWon="0" gender="Female" genderId="1" guild="Adept" guildId="38253" guildUrl="r=Draenor&amp;n=Adept&amp;p=1" name="Efes" race="Night Elf" raceId="4" seasonGamesPlayed="13" seasonGamesWon="7" teamRank="1"/>
		# 			<character battleGroup="" charUrl="r=Draenor&amp;n=Lothaar" class="Paladin" classId="2" contribution="1602" gamesPlayed="10" gamesWon="7" gender="Male" genderId="0" guild="Ultimo Impero Oscuro" guildId="37203" guildUrl="r=Draenor&amp;n=Ultimo+Impero+Oscuro&amp;p=1" name="Lothaar" race="Human" raceId="1" seasonGamesPlayed="20" seasonGamesWon="13" teamRank="1"/>
		# 			<character battleGroup="" charUrl="r=Draenor&amp;n=Lothaar" class="Paladin" classId="2" contribution="1602" gamesPlayed="10" gamesWon="7" gender="Male" genderId="0" guild="Passion" guildId="36659" guildUrl="r=Draenor&amp;n=Passion&amp;p=1" name="Lothaar" race="Human" raceId="1" seasonGamesPlayed="20" seasonGamesWon="13" teamRank="1"/>
		# 		</members>
		# 	</arenaTeam>
		# </arenaTeams>
		class ArenaTeam
			attr_reader :name, :size, :battle_group, :faction, :faction_id, :realm, :realm_url, 
									:games_played, :games_won, :ranking, :rating,
									:season_games_played, :season_games_won, :last_season_ranking, 
									:relevance, :url, :url_escape,
									:characters,	# can be blank on search results
									:emblem
			
			def initialize(elem)
				@name					= elem[:name]
				@size					= elem[:size].to_i
				@battle_group	= elem[:battleGroup]
				@faction			= elem[:faction]
				@faction_id		= elem[:factionId].to_i
				@realm				= elem[:realm]
				@realm_url		= elem[:realmUrl]
				
				@games_played	= elem[:gamesPlayed].to_i
				@games_won		= elem[:gamesWon].to_i
				@ranking			= elem[:ranking].to_i
				@rating				= elem[:rating].to_i
				
				@season_games_played	= elem[:seasonGamesPlayed].to_i
				@season_games_won			= elem[:seasonGamesWon].to_i
				@last_season_ranking	= elem[:lastSeasonRanking].to_i
				
				@relevance		= elem[:relevance].to_i
				@url					= elem[:url]
				
				@emblem				= ArenaTeamEmblem.new(elem%'emblem')
				
				@members = []
				(elem%'members'/:character).each do |character|
					@members << Character.new(character)
				end
			end
		end
		
		class ArenaTeamEmblem
			attr_reader :background, :border_color, :border_style, :icon_colour, :icon_style
			
			def initialize(elem)
				@background		= elem[:background]
				@border_color = elem[:borderColor]
				@border_style = elem[:borderStyle].to_i
				@icon_color		= elem[:iconColor]
				@icon_style		= elem[:iconStyle].to_i
			end
		end
				
	end
end