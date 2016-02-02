class MovieTest
    def initialize()
        @results =[]
    end
    attr_accessor :results
    def mean()
        mean = 0.0
        @results.each do
            |result|
            user_id=result[0]
            movie_id=result[1]
            rating = result[2]
            predicted_rating = result[3]
            mean += (predicted_rating-rating).abs

        end
        return (mean/@results.size())
    end

    def stddev()
        
    end

    def rms()
    end

    def to_a()
    end
end
