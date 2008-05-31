

$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'item.rb'
require 'character.rb'
require 'guild.rb'

# Wowr was written by Ben Humphreys!
# http://wowr.benhumphreys.co.uk/
module Wowr #:nodoc:
	module Classes #:nodoc:

		
		# (fold)
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
		
		# Search results
		# <arenaTeam battleGroup="Reckoning" faction="Horde" factionId="1" gamesPlayed="7" gamesWon="1" lastSeasonRanking="0" name="Cake" ranking="0" rating="1463" realm="Terenas" realmUrl="b=Reckoning&amp;r=Terenas&amp;ts=5&amp;t=Cake&amp;ff=realm&amp;fv=Terenas&amp;select=Cake" relevance="100" seasonGamesPlayed="137" seasonGamesWon="67" size="5" url="r=Terenas&amp;ts=5&amp;t=Cake&amp;select=Cake">
		# 
		#   <emblem background="ffcf2eb5" borderColor="ff5287c9" borderStyle="2" iconColor="ff1411b8" iconStyle="86"/>
		# </arenaTeam>
		
		
	  # <teamInfo>
	  #   <arenaTeam battleGroup="Reckoning" faction="Horde" factionId="1" gamesPlayed="7" gamesWon="1" lastSeasonRanking="0" name="Cake" ranking="2768" rating="1463" realm="Terenas" realmUrl="b=Reckoning&amp;r=Terenas&amp;ts=5&amp;t=Cake&amp;ff=realm&amp;fv=Terenas&amp;select=Cake" relevance="0" seasonGamesPlayed="137" seasonGamesWon="67" size="5" url="r=Terenas&amp;ts=5&amp;t=Cake&amp;select=Cake" urlEscape="r=Terenas&amp;ts=5&amp;t=Cake&amp;select=Cake">
	  #     <emblem background="ffcf2eb5" borderColor="ff5287c9" borderStyle="2" iconColor="ff1411b8" iconStyle="86"/>
	  #     <members>
	  #       <character battleGroup="Reckoning" charUrl="r=Terenas&amp;n=Melsmage" class="Mage" classId="8" contribution="1500" gamesPlayed="0" gamesWon="0" gender="Male" genderId="0" guild="All You Can Eat" guildId="79829" guildUrl="r=Terenas&amp;n=All+You+Can+Eat&amp;p=1" name="Melsmage" race="Undead" raceId="5" realm="Terenas" seasonGamesPlayed="0" seasonGamesWon="0" teamRank="0"/>
	  #       <character battleGroup="Reckoning" charUrl="r=Terenas&amp;n=Kazimierz" class="Warrior" classId="1" contribution="1575" gamesPlayed="0" gamesWon="0" gender="Male" genderId="0" guildId="0" name="Kazimierz" race="Orc" raceId="2" realm="Terenas" seasonGamesPlayed="11" seasonGamesWon="7" teamRank="1"/>
	  #       <character battleGroup="Reckoning" charUrl="r=Terenas&amp;n=Caneye" class="Paladin" classId="2" contribution="1422" gamesPlayed="0" gamesWon="0" gender="Male" genderId="0" guild="All You Can Eat" guildId="79829" guildUrl="r=Terenas&amp;n=All+You+Can+Eat&amp;p=1" name="Caneye" race="Blood Elf" raceId="10" realm="Terenas" seasonGamesPlayed="17" seasonGamesWon="4" teamRank="1"/>
	  #       <character battleGroup="Reckoning" charUrl="r=Terenas&amp;n=Mas" class="Shaman" classId="7" contribution="1519" gamesPlayed="0" gamesWon="0" gender="Male" genderId="0" guild="All You Can Eat" guildId="79829" guildUrl="r=Terenas&amp;n=All+You+Can+Eat&amp;p=1" name="Mas" race="Tauren" raceId="6" realm="Terenas" seasonGamesPlayed="3" seasonGamesWon="2" teamRank="1"/>
	  # 
	  #       <character battleGroup="Reckoning" charUrl="r=Terenas&amp;n=Amolamota" class="Rogue" classId="4" contribution="1528" gamesPlayed="0" gamesWon="0" gender="Female" genderId="1" guildId="0" name="Amolamota" race="Troll" raceId="8" realm="Terenas" seasonGamesPlayed="12" seasonGamesWon="7" teamRank="1"/>
	  #       <character battleGroup="Reckoning" charUrl="r=Terenas&amp;n=Bigred" class="Shaman" classId="7" contribution="1404" gamesPlayed="0" gamesWon="0" gender="Male" genderId="0" guild="All You Can Eat" guildId="79829" guildUrl="r=Terenas&amp;n=All+You+Can+Eat&amp;p=1" name="Bigred" race="Tauren" raceId="6" realm="Terenas" seasonGamesPlayed="14" seasonGamesWon="2" teamRank="1"/>
	  #     </members>
	  #   </arenaTeam>
	  # </teamInfo>
		# (end)
		
		
		class ArenaTeam
			attr_reader :name, :size, :battle_group, :faction, :faction_id, :realm, :realm_url, 
									:games_played, :games_won, :ranking, :rating,
									:season_games_played, :season_games_won, :last_season_ranking, 
									:relevance, :url, :url_escape,
									:characters,	# can be blank on search results
									:emblem
			alias_method :to_s, :name
			
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
				
				# search results don't have members
				if (elem%'members')
					@members = {}
					(elem%'members'/:character).each do |character|
						@members[character[:name]] = ShortCharacter.new(character)
					end
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