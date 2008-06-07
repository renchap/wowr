begin
	require 'wowr'
rescue LoadError
	require 'rubygems'
	require 'wowr'
end

api = Wowr::API.new(:character_name => 'Cake',
                    :guild_name => 'chats puants',
                    :realm => 'Rashgarroth',
                    :locale => 'eu', # defaults to US
                    :lang => 'fr_fr', # remove for locale default language
                    :caching => false) # defaults to true

# Note for all requests it's possible to specify the parameters similar to the
# api constructor. By default it'll use whatever is specified in the API.

# gets character with API default values
default_char = api.get_character_sheet

# specify other character
jim = api.get_character_sheet("Jim", :realm => "Balnazzar", :lang => 'de_de', :caching => false)



# Character requests
my_char = api.get_character_sheet # gets character with API default values
chars = api.search_characters(:search => 'Cake')

# Guild requests
guilds = api.search_guilds("Cake")

# error handling
begin
	no_guild = api.get_guild("moo", :realm => 'bar')
rescue Wowr::Exceptions::GuildNotFound => e
	puts "Guild not found!"
end

my_char.items.each do |item|
	puts item.icon
end

# Items
items = api.search_items("Cake")
item = api.get_item(33924)
if item.reagents
	item.reagents.each do |reagent|
		puts reagent
	end
end

# Arena Teams
arena_teams = api.search_arena_teams("Lemon")
arena_team = api.get_arena_team("Lemon", 2, :realm => "Darksorrow")