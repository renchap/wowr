module Wowr
	module Classes
	  class CharacterAchievementsInfos
	    attr_reader :latest_achievements
	    
	    def initialize elem, api
	      @api = api
	      @latest_achievements = Array.new
	      
	      achievements = elem%'achievements'
	      
	      summary = achievements%'summary'
	      summary.search('achievement').each do |achievement|
	        @latest_achievements << CompletedAchievement.new(achievement)
        end
      end
    end 
    
    class Achievement
      attr_reader :desc, :title, :category_id, :icon, :id, :points, :title
      def initialize achievement
        @desc = achievement['desc']
        @category_id = achievement['categoryId']
        @icon = achievement['icon']
        @id = achievement['id']
        @points = achievement['points']
        @title = achievement['title']
      end
    end
    
    class CompletedAchievement < Achievement
      attr_reader :date_completed
      def initialize achievement
        super(achievement)
        @date_completed = achievement['dateCompleted']
      end
    end
  end
end