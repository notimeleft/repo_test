require_relative 'movie_test'
class MovieData
    def initialize(file = "ml-100k", test = nil)
      @users = []
      (0..943).each { |i| @users[i]=[] }
      @reviews = []
      (0..1682).each { |f| @reviews[f]=[]}
      @score = []
        if test.nil?
            @train_path = "#{file}/u.data"
        else
            @train_path = "#{file}/#{test}.base"
            @test_path = "#{file}/#{test}.test"
        end
        set = data_analysis(@train_path, @test_path)
    end

    def data_analysis(train, test)
        if test.nil?
            load_data(@train_path)
        else
            load_data(@test_path)
        end
        return @users
    end

    def load_data(file_path)
        file_object = open(file_path, 'r')
        text_line = file_object.readlines
        text_line.each do
            |line|
                line = line.split(" ")
                user = line[0].to_i
                review_num = line[1].to_i
                score = line[2].to_i

                @users[user].push({review_num => score})

                @reviews[review_num].push(user)
                @score[review_num]=@score[review_num].to_i+score
        end
        file_object.close()

    end
    def similarity (user1, user2)
        one = @users[user1]
        two = @users[user2]
        user1_pref = []
        one.each {|k| k.each {|key, value| user1_pref.push(key)}}
        user2_pref = []
        two.each {|k| k.each {|key, value| user2_pref.push(key)}}
        user_common = user1_pref & user2_pref
        count = 0
        user_common.each do
          |movie_id|

          one_score = 0
          two_score = 0
          one.each {
            |k| k.each {|k,v|
              if movie_id.to_i == k.to_i

                one_score = v
              end
            }
          }
          two.each {
            |k| k.each {|k,v|
              if movie_id.to_i == k.to_i

                two_score = v
              end
            }
          }
          if (one_score-two_score).abs <=1
              count += 1
          end
        end
        return count
    end

    def most_similar(user)
        count = 0
        user_id = 0
        ranking = {}
        (1..943).each do
          |i|
          next if user == i
          score = similarity(user, i)
          ranking[i] = score
        end

        final_ranking = ranking.sort_by {|id, score| score.to_f}
        final_rank = []
        final_ranking.each {|id, score| final_rank.push(id)}
        final_rank.reverse!

        return final_rank
    end

    def rating(user, movie)
        ratings = @users[user]
        score = 0
        ratings.each {
        |hash| hash.each {|k, v|
            if k == movie
              score = v
              break
            end
          }
        }
        return score
    end

    def predict(user, movie)
        rank = most_similar(user)
        score = []
        rank.each do
            |current_user|
            user_reviews= @users[current_user]
            user_reviews.each do
              |hash| hash.each{
                |k,v|
                if k == movie
                  score.push(v)
                  break
                end
              }

            end
        end

        return score[0].to_f
    end

    def movies(user)
        movies = @users[user]
        final_list = []
        movies.each do
          |hash| hash.each {|k,v| final_list.push(k)}
        end
        return final_list
    end

    def viewers(movie)
        return @reviews[movie]
    end

    def run_test(k=nil)
        test_object = MovieTest.new()
        if k.nil?
        testing = open(@test_path,'r')
        #load_data(testing)
        @users.each_with_index do
            |user, i|
            if user.nil? || user.empty?
                next
            end
            @users[i].each {
              |current_user|
              test_object.results.push(predict(i, current_user))
            }

        end
        else

        end
    end
end
b = MovieData.new("ml-100k")
#a = MovieData.new("ml-100k", :u1)
puts b.rating(943, 1331)
puts b.movies(943)

puts "viewers: #{b.viewers(1330)}"

puts "prediction: "+b.predict(943,1330).to_s
#a.run_test()
