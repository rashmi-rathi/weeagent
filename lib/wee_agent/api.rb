require 'httparty'

module WeeAgent
  class API
    def initialize(access_token: , environment: :development)
      @access_token = access_token
      @environment = environment
      @url = free_agent_url
    end

    def request(verb:, path:, query: {}, body: {})
      free_agent_url = "#{@url}/#{path}"
      HTTParty.send(verb, free_agent_url, { query: query, body: body, headers: headers })
    end

    private

    def headers
      @authorised_headers ||= {
        'Authorization' => "Bearer #{@access_token}",
        'Accept' => 'application/json',
        'User-Agent' => 'API Testing'
      }
    end


    def free_agent_url
      if @environment.eql?(:live) || @environment.eql?(:production)
        'https://api.freeagent.com/v2'
      else
        'https://api.sandbox.freeagent.com/v2'
      end
    end
  end
end
