module ScoreMethods
  def menu_score
    action = menu_options(["cambiar nombre", "back"])

    loop do
      case action
      when "cambiar nombre"
        change_name
        break
      when "back"
        break
      else
        puts "Invalid Option\n".colorize(:red)
      end
    end
  end

  def score_points(questions)
    puts "Well done! Your score is #{@score} out of a total of #{questions} questions".colorize(:blue)
    puts "--------------------------------------------------"
  end

  def parse_scores(filename)
    rows = []
    file_scores = File.read(filename)
    table_scores = file_scores.empty? ? [] : JSON.parse(file_scores, symbolize_names: true)
    table_sort_by = table_scores.sort { |first, second| second[:score] <=> first[:score] }

    table_sort_by.map do |hash|
      data = hash[:score].to_s
      score = hash[:score] >= 50 ? data.colorize(:green) : data.to_s.colorize(:red)
      rows << [hash[:name].capitalize, score, hash[:questions]]
    end

    show_table_scores(rows)
  end

  def show_table_scores(rows)
    table = Terminal::Table.new
    table.title = "Top Scores"
    table.headings = ["Name", "Score", "Questions"]
    table.rows = rows
    puts table
  end

  def change_name
    file_scores = File.read(@filename)
    table_scores = file_scores.empty? ? [] : JSON.parse(file_scores, symbolize_names: true)

    dato = text_coment("What name do you want to change?")
    new_name = text_coment("What is the new name?")

    table_scores.each do |hash|
      hash[:name] == dato ? hash[:name] = new_name : hash[:name]
    end

    data_write = table_scores.to_json
    text_invalid = "The user #{dato.capitalize} doesn't exist.".colorize(:red)
    sym = { symbolize_names: true }

    response = table_scores == JSON.parse(file_scores, sym) ? text_invalid : File.write(@filename, data_write)

    puts response == text_invalid ? response : ""

    parse_scores(@filename)
    menu_score
  end
end
