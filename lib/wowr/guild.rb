# TODO: Item sources - Vendors
# sourceType.vendor
# sourceType.questReward
# sourceType.createdBySpell

$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.dirname(__FILE__))

# TODO: Split up classes depending on subject?　　Character, Item, Guild, ArenaTeam
require 'item.rb'

# Wowr was written by Ben Humphreys!
# http://wowr.benhumphreys.co.uk/
module Wowr #:nodoc:
	module Classes #:nodoc:
		
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
				@name_url			= guild[:nameUrl] == "" ? nil : elem[:nameUrl]
				@url					= guild[:url]
				@realm				= guild[:realm]
				@realm_url		= guild[:realmUrl] == "" ? nil : elem[:realmUrl]
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
		
	end
end