$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.dirname(__FILE__))

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
	end
end