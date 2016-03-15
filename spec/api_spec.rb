require 'spec_helper'

describe WeeAgent::API, wip: true do
  describe "Invoice creation" do
    before do
      pending
    end

    it 'knows how to create an invoice' do
      expect(WeeAgent::API).to receive(:request).with(:post, 'invoices', {
        query: invoice.build_free_agent_invoice
      })

      WeeAgent::Invoice.create(:access_token => "12345", :contact => "Mr. Jones",
        payment_terms_in_days: 30, :dated_on => Date.new(2016, 3, 15))
    end

    it 'knows how to send an invoice via email', wip: true do
      body =
        { invoice:
            { email:
                { to: 'john@wick.com',
                  from: 'dan@wegotcoders.com',
                  body: "Here's your invoice",
                  subject: 'Invoice',
                  email_to_sender: true
                }
            }
        }

      expect(WeeAgent::API).to receive(:request).with(verb: :post, path: "invoices/#{invoice.free_agent_id}/send_email", body: body)
      WeeAgent::API.email_invoice(invoice)
    end
  end
end