require "httparty"
require "json"

class CliviaApi
  include HTTParty
  base_uri "https://opentdb.com/api_token.php?command=request"

  def self.questions
    response_token = get(base_uri)
    base_url_with_token = "https://opentdb.com/api.php?amount=10&token="
    token = JSON.parse(response_token.body, symbolize_names: true)
    response = get("#{base_url_with_token}#{token[:token]}")
    JSON.parse(response.body, symbolize_names: true)
  end
end