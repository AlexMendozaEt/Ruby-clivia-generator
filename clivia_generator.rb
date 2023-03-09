require "htmlentities"
require_relative "text_input"
require_relative "clivia_api"

class CliviaGenerator
  include TextClivia

  def initialize(filename)
    @decoder = HTMLEntities.new
    @filename = filename
    @questions = []
    @score = 0
    @count = 1
  end

  def start
    welcome
    action = menu_options(%w[random scores exit])
    case  action
    when "random" then ask_questions
    end
  end

  def random_trivia
    @questions = CliviaApi.questions[:results]
  end

  def ask_questions
    random_trivia
    @questions.map do |question|
      options_data = []
      puts "Category: #{@decoder.decode(question[:category])} | Difficulty: #{@decoder.decode(question[:difficulty])}"
      puts "Question: #{@decoder.decode(question[:question])}"
      options_data = question[:incorrect_answers]
      options_data << question[:correct_answer]
      if options_data.size == 2
        options = options_data.sort_by {|s| s.size } 
      else
        options = options_data.sample(options_data.size)
      end
      results_hash = []
      until options.size == 0
        results_hash << new_hash = {id: @count, result: @decoder.decode(options.shift)}
        puts "#{new_hash[:id]}. #{new_hash[:result]}"
        @count += 1
      end
      print ">"
      response = gets.chomp {}
      results_user = results_hash.find {|hash| hash[:id] == response.to_i}
      if results_user[:result] == question[:correct_answer]
        puts "#{results_user[:result]}... Correct!"
      else
        puts "#{results_user[:result]}... Incorrect!"
        puts "The correct answer was: #{question[:correct_answer]}"
      end
      @count = 1
    end
    # ask each question
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
  end

  def save(data)
    # write to file the scores data
  end

  def parse_scores
    # get the scores data from file
  end

  def load_questions
    # ask the api for a random set of questions
    # then parse the questions
  end

  def parse_questions
    # questions came with an unexpected structure, clean them to make it usable for our purposes
  end

  def print_scores
    # print the scores sorted from top to bottom
  end
end
