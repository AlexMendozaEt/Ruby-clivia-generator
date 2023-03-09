require "htmlentities"
require "json"
require "terminal-table"
require "colorize"
require_relative "Helpers/helpers_questions"
require_relative "Helpers/helpers_save"
require_relative "Helpers/helpers_score"
require_relative "text_methods"
require_relative "clivia_api"

class CliviaGenerator
  include TextMethods
  include QuestionsMethods
  include SaveMethods
  include ScoreMethods
  def initialize(filename)
    @decoding = HTMLEntities.new
    @filename = filename
    @questions = nil
    @score = 0
    @count = 1
    @number_questions = nil
    File.open(@filename, "w") unless File.exist?(@filename)
    @data_scores = []
  end

  def start
    loop do
      welcome
      action = menu_options(["random", "scores", "reset scores", "exit"])
      case action
      when "random" then numb_quest = number_of_questions
                         ask_questions(numb_quest)
      when "scores" then parse_scores(@filename)
                         menu_score
      when "reset scores" then File.open(@filename, "w")
      when "exit" then puts "Thanks for playing!".colorize(:green)
                       break
      end
    end
  end
end
