require_relative "clivia_generator"

custom_filename = ARGV.shift

clivia = CliviaGenerator.new(custom_filename.nil? ? "scores.json" : custom_filename)
clivia.start
