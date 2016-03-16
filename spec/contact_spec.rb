require 'spec_helper'

describe WeeAgent::Contact do
  before do
    @contact = WeeAgent::Contact.new(access_token: 'test_access_token')
  end

  it 'makes a POST request' do
    expect(@contact).to receive(:request).with(
      verb: :post,
      path: 'contacts',
      query: {
        contact: {
          organisation_name: 'John Wick Ltd.',
          first_name: 'John',
          last_name: 'Wick',
          email: 'john@wick.com'
        }
      }
    )

    @contact.create(organisation_name: 'John Wick Ltd.', first_name: 'John', last_name: 'Wick', email: 'john@wick.com')
  end
end
