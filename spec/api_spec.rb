require 'spec_helper'

describe WeeAgent::API do
  before do
    @api = WeeAgent::API.new(access_token: 'test_access_token')
  end

  describe '#url' do
    it 'uses sandbox api by default' do
      expect(@api.url).to eq('https://api.sandbox.freeagent.com/v2')
    end

    it 'uses the live api if given explicit option' do
      api = WeeAgent::API.new(access_token: 'test_access_token', environment: :production)

      expect(api.url).to eq('https://api.freeagent.com/v2')
    end
  end

  describe '#contact' do
    it 'returns contact class' do
      expect(@api.contact).to be_instance_of(WeeAgent::Contact)
    end
  end

  describe '#invoice' do
    it 'returns invoice class' do
      expect(@api.invoice).to be_instance_of(WeeAgent::Invoice)
    end
  end
end
