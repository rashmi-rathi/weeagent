require 'spec_helper'

describe WeeAgent::Invoice do
  before do
    @invoice = WeeAgent::Invoice.new(access_token: 'test_access_token')
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

      @invoice.create(contact_id: 1, dated_on: Date.today.to_s, payment_terms_in_days: 30, items: [])
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

    it 'raises an exception if the response has errors' do
      body = {"errors"=>{"error"=>{"message"=>"Access token not recognised"}}}.to_json
      stub_request(:post, "https://api.sandbox.freeagent.com/v2/invoices/1/send_email").with(:body => "invoice[email][to]=test%40test.com&invoice[email][from]=test%40test.com&invoice[email][body]=&invoice[email][subject]=&invoice[email][email_to_sender]=false", :headers => {'Accept'=>'application/json', 'Authorization'=>'Bearer test_access_token', 'User-Agent'=>'API Testing'}).to_return(:status => 401, :body => body, :headers => {})

      expect {

        @invoice.email(invoice_id: 1, to: 'test@test.com', from: 'test@test.com')
      }.to raise_error( WeeAgent::Exception )
    end
  end
end
