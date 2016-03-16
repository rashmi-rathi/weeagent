module WeeAgent
  class Invoice < API
    def initialize(args)
      super(args)
    end

    def create(contact_free_agent_url, items)
      request(verb: :post, path: 'invoices', query: build_invoice(contact_free_agent_url, items))
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
  end
end
