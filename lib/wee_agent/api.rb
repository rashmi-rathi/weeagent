module WeeAgent
  class API
    def initialize(access_token: , environment: :development)
      @access_token = access_token
      @environment = environment
      @url = free_agent_url
    end

    def request(verb:, path:, query: {}, body: {})
      free_agent_url = "#{base_url}/#{path}"
      HTTParty.send(verb, free_agent_url, { query: query, body: body, headers: headers })
    end

    def email_invoice(invoice)
      invoice_query = build_invoice_email_query(invoice)
      response = request(verb: :post, path: "invoices/#{invoice.free_agent_id}/send_email", body: invoice_query)
      return unless response
      response.code.eql?(200) ? true : false
    end

    def invoices
      HTTParty.get("#{base_url}/invoices", headers: headers)
    end

    def get_invoice(invoice_id)
      HTTParty.get("#{base_url}invoices/#{invoice_id}", headers: headers)
    end

    def authentication
      @@authentication ||= Oauth::Authentication.find_by_provider('freeagent')
    end

    private

    def headers
      @authorised_headers ||= {
        'Authorization' => "Bearer #{access_token}",
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

    def build_invoice_email_query(invoice)
      {
        invoice: {
          email: {
            to: invoice.trainee.email,
            from: 'dan@wegotcoders.com',
            body: "Here's your invoice",
            subject: 'Invoice',
            email_to_sender: true
          }
        }
      }
    end
  end
end
