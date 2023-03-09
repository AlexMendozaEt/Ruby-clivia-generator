require_relative "clivia_generator"


custom_filename = ARGV.shift

trivia = CliviaGenerator.new(custom_filename.nil? ? "scores.json" : new_file)
trivia.start
