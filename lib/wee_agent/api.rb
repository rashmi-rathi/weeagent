module WeeAgent
  class API
    def self.base_url
      @@url ||= free_agent_url
    end

    def self.request(verb:, path:, query: {}, body: {})
      free_agent_url = "#{base_url}/#{path}"
      HTTParty.send(verb, free_agent_url, { query: query, body: body, headers: headers })
    end

    def self.create_invoice(invoice)
      response = request(:post, 'invoices', query: invoice.build_free_agent_invoice)
    end

    def self.email_invoice(invoice)
      invoice_query = build_invoice_email_query(invoice)
      response = request(verb: :post, path: "invoices/#{invoice.free_agent_id}/send_email", body: invoice_query)
      return unless response
      response.code.eql?(200) ? true : false
    end

    def self.invoices
      HTTParty.get("#{base_url}/invoices", headers: headers)
    end

    def self.get_invoice(invoice_id)
      HTTParty.get("#{base_url}invoices/#{invoice_id}", headers: headers)
    end

    def self.headers
      @@authorised_headers ||= {
        'Authorization' => "Bearer #{authentication.access_token}",
        'Accept' => 'application/json',
        'User-Agent' => 'API Testing'
      }
    end

    def self.authentication
      @@authentication ||= Oauth::Authentication.find_by_provider('freeagent')
    end

    private

    def self.free_agent_url
      if Rails.env.production?
        'https://api.freeagent.com/v2'
      else
        'https://api.sandbox.freeagent.com/v2'
      end
    end

    def self.build_invoice_email_query(invoice)
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
