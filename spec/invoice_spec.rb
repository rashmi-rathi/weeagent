require 'spec_helper'

describe WeeAgent::Invoice do
  before do
    @invoice = WeeAgent::Invoice.new(access_token: 'test_acces_token')
  end

  describe '.create' do
    it 'makes a POST request' do
      expect(@invoice).to receive(:request).with(
        verb: :post,
        path: 'invoices',
        query: {
          :invoice => {
            :contact => 'https://api.sandbox.freeagent.com/v2/contacts/1',
            :payment_terms_in_days => 30,
            :dated_on => Date.today.to_s,
            :invoice_items => []
          }
        }
      )

      @invoice.create(1, [])
    end
  end

  describe '.email' do
    it 'makes a POST request' do
      expect(@invoice).to receive(:request).with(
        verb: :post,
        path: 'invoices/1/send_email',
        body: {
          invoice: {
            email: {
              to: 'john@wick.com',
              from: 'john@wick.com',
              body: 'test body',
              subject: 'test subject',
              email_to_sender: false
            }
          }
        }
      )

      @invoice.email(invoice_id: 1, to: 'john@wick.com', body: 'test body', from: 'john@wick.com', subject: 'test subject')
    end
  end
end
