module WeeAgent
  module InvoiceBuilder
    def self.included(klass)
      klass.class_eval do
        before_create :set_amount
        before_create :create_free_agent_invoice
      end
    end

    def build_free_agent_invoice
      {
        :invoice => {
          :contact => trainee.free_agent_url,
          :payment_terms_in_days => 30,
          :dated_on => Date.today.to_s,
          :invoice_items => items
        }
      }
    end

    def create_free_agent_invoice
      invoice_response = HTTParty.post("#{API.base_url}/invoices",
        headers: API.headers,
        :query => {
          :invoice => {
            :contact => trainee.free_agent_url,
            :payment_terms_in_days => 30,
            :dated_on => Date.today.to_s,
            :invoice_items => items
          }
        }
      )

      if invoice_response['errors']
        raise API::Exception.new invoice_response['errors'].first['message']
      else
        # hack for testing
        response = invoice_response["invoice"].presence || JSON.try(:parse, invoice_response)
        self.free_agent_id = response["url"].split("/").last
      end
    end

    private

    def set_amount
      custom? ? amount : total
    end

    def main_item_cost
      custom? ? amount : offering.price
    end

    def items
      items = [
        {
        :description => summary,
        :item_type => 'Training',
        :price => main_item_cost,
        :quantity => 1
        }
      ]

      if application.accommodation_required? && !custom
        items << {
          :description => "Accommodation",
          :item_type => 'Services',
          :price => WeGotCoders.accommodation_cost,
          :quantity => 1
        }
      end

      items
    end
  end
end
