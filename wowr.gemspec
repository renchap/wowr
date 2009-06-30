# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wowr}
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Humphreys", "Peter Wood", "Renaud Chaput", "Ken Preudhomme"]
  s.date = %q{2009-04-04}
  s.description = %q{Wowr is a Ruby library for accessing data in the World of Warcraft Armory. It provides an object-oriented interface to the XML data provided by the armory, giving access to items, characters, guilds and arena teams. It is designed for both single users and larger guild or portal sites for many users.}
  s.email = %q{peter+wowr@alastria.net}
  s.extra_rdoc_files = ["README"]
  s.files = ["VERSION.yml", "lib/wowr", "lib/wowr/calendar.rb", "lib/wowr/exceptions.rb", "lib/wowr/dungeon.rb", "lib/wowr/arena_team.rb", "lib/wowr/character.rb", "lib/wowr/achievements.rb", "lib/wowr/guild.rb", "lib/wowr/guild_bank.rb", "lib/wowr/general.rb", "lib/wowr/extensions.rb", "lib/wowr/item.rb", "lib/wowr.rb", "test/xml", "test/xml/dungeonStrings.xml", "test/xml/armory_search.xml", "test/xml/character-talents.xml", "test/xml/itemSearch.xml", "test/xml/character_info.xml", "test/xml/arena_team_single.xml", "test/xml/character-reputation.xml", "test/xml/example.xml", "test/xml/item-tooltip.xml", "test/xml/item_search.xml", "test/xml/character-sheet.xml", "test/xml/benedictt.xml", "test/xml/armory-search.xml", "test/xml/item-info.xml", "test/xml/arena_team_search.xml", "test/xml/character-skills.xml", "test/xml/character_search.xml", "test/xml/guild-info.xml", "test/xml/dungeons.xml", "test/wowr_item_test.rb", "test/wowr_dungeon_test.rb", "test/wowr_character_test.rb", "test/wowr_arena_team_test.rb", "test/wowr_guild_test.rb", "test/wowr_test.rb", "README"]
  s.has_rdoc = true
  s.homepage = %q{http://wowr.rubyforge.org/}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{wowr}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A Ruby library for the World of Warcraft Armory}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
