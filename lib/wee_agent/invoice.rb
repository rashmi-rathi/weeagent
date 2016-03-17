module WeeAgent
  class Invoice < API
    def create(contact_free_agent_url, items)
      request(verb: :post, path: 'invoices', query: build_invoice(contact_free_agent_url, items))
    end

    def all
      request(verb: :get, path: 'invoices')
    end

    def get_invoice(invoice_id)
      request(verb: :get, path: "#{@url}/invoices/#{invoice_id}")
    end

    def email(invoice_id:, to:, from:, body: '', subject: '', email_to_sender: false)
      query = build_email_query(to: to, from: from, body: body, subject: subject, email_to_sender: email_to_sender)
      request(verb: :post, path: "invoices/#{invoice_id}/send_email", body: query)
    end

    private

    def contact_url(contact_id)
      "#{@url}/contacts/#{contact_id}"
    end

    def build_invoice(contact_id, items)
      {
        :invoice => {
          :contact => contact_url(contact_id),
          :payment_terms_in_days => 30,
          :dated_on => Date.today.to_s,
          :invoice_items => items
        }
      }
    end

    def build_email_query(to:, from:, body:, subject:, email_to_sender: false)
      {
        invoice: {
          email: {
            to: to,
            from: from,
            body: body,
            subject: subject,
            email_to_sender: email_to_sender
          }
        }
      }
    end
  end
end
