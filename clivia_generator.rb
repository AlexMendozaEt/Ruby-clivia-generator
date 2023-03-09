require "htmlentities"
require "json"
require "terminal-table"
require "colorize"
require_relative "helpers_methods"
require_relative "clivia_api"

class CliviaGenerator
  include TextClivia
  def initialize(filename)
    @decoder = HTMLEntities.new
    @filename = filename
    @questions = []
    @score = 0
    @count = 1
    File.open(@filename, "w") unless File.exist?(@filename)
    @data_scores = []
  end

  def start
    loop do
      welcome
      action = menu_options(["random", "scores", "reset scores", "exit"])
      case action
      when "random" then ask_questions
      when "scores" then parse_scores(@filename)
      when "reset scores" then File.open(@filename, "w")
      when "exit" then puts "Thanks for playing!".colorize(:green)
                       break
      end
    end
  end

  def random_trivia
    @questions = CliviaApi.questions[:results]
  end

  def make_question(category, question, difficulty, incorrect_answers, correct_answer)
    options_data = incorrect_answers
    options_data << correct_answer
    begin
      puts "Category: #{@decoder.decode(category)} | Difficulty: #{@decoder.decode(difficulty)}"
      puts "Question: #{@decoder.decode(question)}"
      options = if options_data.size == 2
                  options_data.sort_by(&:size)
                else
                  options_data.sample(options_data.size)
                end
      valid_anwers(options, correct_answer)
    rescue NoMethodError
      puts "Invalid option\n".colorize(:red)
      @count = 1
      retry
    end
  end

  def valid_anwers(options, correct_answer)
    results_hash = []
    until options.empty?
      results_hash << new_hash = { id: @count, result: @decoder.decode(options.shift) }
      puts "#{new_hash[:id]}. #{new_hash[:result]}"
      @count += 1
    end
    print ">"
    response = gets.chomp
    results_user = results_hash.find { |hash| hash[:id] == response.to_i }
    if results_user[:result] == correct_answer
      puts "#{results_user[:result]}... Correct!\n".colorize(:green)
      @score += 10
    else
      puts "#{results_user[:result]}... Incorrect!".colorize(:red)
      puts "The correct answer was: #{@decoder.decode(correct_answer)}\n".colorize(:green)
    end
  end

  def ask_questions
    random_trivia
    @questions.map do |question|
      make_question(question[:category], question[:question], question[:difficulty], question[:incorrect_answers],
                    question[:correct_answer])
      @count = 1
    end
    safe?(@score)
    loop do
      action = text_coment("Do you want to save your score? (y/n)")
      case action
      when "y" then save
                    @score = 0
                    break
      when "n" then @score = 0
                    break
      else
        puts "Invalid Option\n".colorize(:red)
      end
    end
  end

  def save
    data = text_coment("Type the name to assign to the score")
    name = data.empty? ? "Anonymous" : data
    user_data = { name: name, score: @score }
    data_scores = File.read(@filename)
    score_data = data_scores.empty? ? [] : JSON.parse(data_scores)
    if score_data.empty?
      @data_scores << user_data
      File.write(@filename, @data_scores.to_json)
    else
      score_data << user_data
      File.write(@filename, score_data.to_json)
    end
  end
end
