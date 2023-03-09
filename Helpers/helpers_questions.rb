module QuestionsMethods
  def number_of_questions
    user_questions = text_coment("If you want a certain number of questions, enter the amount.")
    user_questions = text_coment("Cannot be less than 10") until user_questions.to_i >= 10 || user_questions.empty?

    @number_questions = user_questions.empty? ? 10 : user_questions
    puts "You have chosen #{@number_questions} questions.".colorize(:green)

    @number_questions
  end

  # The name of the parameter is confusing, 
  # what is coming here is the number of questions, not "questions" 👇
  def ask_questions(questions)
    # I think it is not necessary to instantiate `@questions`
    random_trivia(questions).map do |question|
      make_question(
        question[:category], 
        question[:question], 
        question[:difficulty], 
        question[:incorrect_answers],
        question[:correct_answer]
      )

      @count = 1
    end

    # It is also not necessary to go through instance 
    # variable arguments (`@score`) because since it is 
    # an instance, the whole app knows it.
    score_points(questions)

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

  # The name of the parameter is confusing, 
  # what is coming here is the number of questions, not "questions" 👇
  def random_trivia(questions)
    CliviaApi.questions(questions)[:results]
  end

  def make_question(category, question, difficulty, incorrect_answers, correct_answer)
    # opptions_data = incorrect_answers + correct_answer
    # 👆 This is the same as this other 👇
    options_data = incorrect_answers
    options_data << correct_answer
    
    begin
      puts "Category: #{@decoding.decode(category)} | Difficulty: #{@decoding.decode(difficulty)}"
      puts "Question: #{@decoding.decode(question)}"
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
      results_hash << new_hash = { id: @count, result: @decoding.decode(options.shift) }
      puts "#{new_hash[:id]}. #{new_hash[:result]}"
      @count += 1
    end
    print ">"
    response = gets.chomp
    results_user = results_hash.find { |hash| hash[:id] == response.to_i }
    if results_user[:result] == @decoding.decode(correct_answer)
      puts "#{results_user[:result]}... Correct!\n".colorize(:green)
      @score += 10
    else
      puts "#{results_user[:result]}... Incorrect!".colorize(:red)
      puts "The correct answer was: #{@decoding.decode(correct_answer)}\n".colorize(:green)
    end
  end
end
