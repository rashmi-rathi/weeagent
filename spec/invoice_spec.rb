require 'spec_helper'

describe WeeAgent::Invoice do
  describe '.create' do
    before do
      @api = WeeAgent::Invoice.new(access_token: 'test_acces_token')
    end

    it 'makes a POST request', focus: true do
      expect(@api).to receive(:request).with(
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

      @api.create(1, [])
    end
  end
end
