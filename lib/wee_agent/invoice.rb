module WeeAgent
  class Invoice < API
    attr_reader :free_agent_id

    #items = [
    #  {
    #    :description => "SEO Training and Workshop",
    #    :item_type => "Training",
    #    :price => 800, #    :quantity => 1 #  },
    #  {:description => "Accommodation",
    #   :item_type => "Services",
    #   :price => 75,
    #   :quantity => 1
    #  }
    #]

    def create(contact_id:, dated_on:, payment_terms_in_days:, items:)
      response = request(
        verb: :post,
        path: 'invoices',
        query: build_invoice(
          contact_id,
          payment_terms_in_days,
          dated_on,
          items
        )
      )

      handle_response(response)
    end

    def all
      response = request(verb: :get, path: 'invoices')
      handle_response(response)
    end

    def get_invoice(invoice_id)
      response = request(verb: :get, path: "#{@url}/invoices/#{invoice_id}")
      handle_response(response)
    end

    def email(invoice_id:, to:, from:, body: '', subject: '', email_to_sender: false)
      query = build_email_query(to: to, from: from, body: body, subject: subject, email_to_sender: email_to_sender)
      response = request(verb: :post, path: "invoices/#{invoice_id}/send_email", body: query)
      handle_response(response)
    end

    private

    def contact_url(contact_id)
      "#{@url}/contacts/#{contact_id}"
    end

    def build_invoice(contact_id, payment_terms_in_days, dated_on, items)
      {
        :invoice => {
          :contact => contact_url(contact_id),
          :payment_terms_in_days => payment_terms_in_days,
          :dated_on => dated_on,
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
