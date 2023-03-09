require "httparty"
require "json"

class CliviaApi
  include HTTParty
  base_uri "https://opentdb.com"

  def self.questions(questions)
    token = url_token

    response = get("/api.php?amount=#{questions}&token=#{token[:token]}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.url_token
    response = get("/api_token.php?command=request")
    JSON.parse(response.body, symbolize_names: true)
  end
end
