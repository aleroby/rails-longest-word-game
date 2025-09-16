require "open-uri"

class GamesController < ApplicationController
  def new()
    vowels = %w[A E I O U Y]
    other_letters = ("A".."Z").to_a - vowels
    grid = []
    (10 / 2).times { grid << vowels.sample }
    grid << other_letters.sample while grid.size < 10
    @letters = grid.shuffle
  end

  def in_grid(word, letters)
    word.upcase.chars.tally.all? { |character, count| letters.tally[character].to_i >= count }
  end

  def in_dictionary(word)
    url = "https://dictionary.lewagon.com/#{word}"
    dictionary_check = URI.parse(url).read
    hash_check_result = JSON.parse(dictionary_check)
    hash_check_result["found"]
  end

  def score()
    word = params[:word]
    # p word
    letters = params[:letters].gsub(" ", "").chars
    # p letters
    if in_grid(word, letters)
      if in_dictionary(word)
        @score = "Congratulations! #{word.upcase} is a valid English word"
      else
        @score = "Sorry but #{word.upcase} does not seem to be a valid English word"
      end
    else
      @score = "Sorry but! #{word.upcase} can't be built out of #{letters}"
    end
  end
end
