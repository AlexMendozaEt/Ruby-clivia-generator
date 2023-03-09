require "colorize"

module HelpersMethods
  def welcome
    puts ["###################################",
          "#    Welcome to Clivia Generator  #",
          "###################################"].join("\n")
  end

  def menu_options(menu)
    input = ""
    loop do
      puts menu.join(" | ")
      print "> "
      input = gets.chomp.strip.downcase

      break if menu.include?(input)

      puts "Invalid option\n".colorize(:red)
    end
    input
  end

  def text_coment(text)
    puts text.to_s
    print ">"
    gets.chomp.strip.downcase
  end

  def score_points(score)
    puts "Well done! Your score is #{score}".colorize(:blue)
    puts "--------------------------------------------------"
  end

  def parse_scores(filename)
    file_scores = File.read(filename)
    table_scores = file_scores.empty? ? [] : JSON.parse(file_scores, symbolize_names: true)
    rows = []
    table_sort_by = table_scores.sort { |first, second| second[:score] <=> first[:score] }
    table_sort_by.map do |hash|
      data = hash[:score].to_s
      score = hash[:score] >= 50 ? data.colorize(:green) : data.to_s.colorize(:red)
      rows << [hash[:name].capitalize, score]
    end
    show_table_scores(rows)
  end

  def show_table_scores(rows)
    table = Terminal::Table.new
    table.title = "Top Scores"
    table.headings = ["Name", "Score"]
    table.rows = rows
    puts table
  end
end
