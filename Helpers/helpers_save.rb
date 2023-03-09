module SaveMethods
  def save
    data = text_coment("Type the name to assign to the score")
    name = data.empty? ? "anonymous" : data
    user_data = { name: name, score: @score, questions: @number_questions }

    data_scores = File.read(@filename)
    score_data = data_scores.empty? ? nil : JSON.parse(data_scores)

    if data_scores.empty?
      @data_scores << user_data
      File.write(@filename, @data_scores.to_json)
    else
      score_data << user_data
      File.write(@filename, score_data.to_json)
    end
  end
end
