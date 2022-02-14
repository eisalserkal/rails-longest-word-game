require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def included
    @response.chars.sort.all? { |letter| @grid.include?(letter) }
  end

  def english_word
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{@response}").read
    json = JSON.parse(response)
    json['found']
  end

  def score
    @response = params[:word].upcase
    @grid = params[:grid]
    grid_letters = @grid.each_char { |letter| print letter, '' }
    if included
      if english_word
        @answer = "Congratulations! #{@response.upcase} is a valid English Word"
      else
        @answer = "Sorry but #{@response.upcase} does not seem to be a valid English word..."
      end
    else
      @answer = "Sorry but #{@response.upcase} can't be built out of #{grid_letters}"
    end
  end
end
