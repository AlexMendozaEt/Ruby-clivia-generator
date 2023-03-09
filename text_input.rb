module TextClivia
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
        p input
        puts "Invalid option"
      end
      input
  end
end