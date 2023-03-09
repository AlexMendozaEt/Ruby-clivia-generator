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

  def make_question(category,question,difficulty,incorrect_answers,correct_answer)
      options_data = []
      options_data = incorrect_answers
      options_data << correct_answer
      begin
      puts "Category: #{@decoder.decode(category)} | Difficulty: #{@decoder.decode(difficulty)}"
      puts "Question: #{@decoder.decode(question)}"
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
      if results_user[:result] == correct_answer
        puts "#{results_user[:result]}... Correct!\n\n"
        @score += 10
      else
        puts "#{results_user[:result]}... Incorrect!"
        puts "The correct answer was: #{correct_answer}\n\n"
      end
    rescue NoMethodError
      puts "Invalid option\n\n"
      @count = 1
    retry
    end
  end

  def ask_questions
    random_trivia
    @questions.map do |question|
      make_question(question[:category],question[:question],question[:difficulty],question[:incorrect_answers],question[:correct_answer])
      @count = 1
    end
    puts "Well done! Your score is #{@score}"
    puts "--------------------------------------------------"
    loop do 
      puts "Do you want to save your score? (y/n)"
      print ">"
      action = gets.chomp.strip.downcase
      case action
      when "y" 
        puts "yes"
      when "n" 
        puts "no"
      else 
        puts "Invalid Option"
      end
    end
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
