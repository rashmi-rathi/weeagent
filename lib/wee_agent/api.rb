require 'httparty'

module WeeAgent
  class API
    attr_reader :url

    def initialize(access_token: , environment: :development)
      @access_token = access_token
      @environment = environment
      @url = free_agent_url
    end

    def handle_response(response)
      return unless response
      return response if response.code.eql?(200)
      raise Exception.new(response['errors']['error']['message']) if response['errors']
      response
    end

    def request(verb:, path:, query: {}, body: {})
      free_agent_url = "#{@url}/#{path}"
      HTTParty.send(verb, free_agent_url, { query: query, body: body, headers: headers })
    end

    def contact
      @contact ||= Contact.new(access_token: @access_token, environment: @environment)
    end

    def invoice
      @invoice ||= Invoice.new(access_token: @access_token, environment: @environment)
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
