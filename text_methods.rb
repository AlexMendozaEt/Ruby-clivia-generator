require "colorize"

module TextMethods
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
end
