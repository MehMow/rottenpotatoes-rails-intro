class Movie < ActiveRecord::Base
  
  # for part 1
  
  
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  
    
  def self.with_ratings(ratings)
    if ratings == []
        return self.all
    else
      return self.where(rating: ratings) # "rating = ?", [ratings])#('ratings IN (?)', ratings)
    end
  end
  
  
    
  # end of part 1
end
