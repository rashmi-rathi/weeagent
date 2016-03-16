require 'spec_helper'

describe WeeAgent::API, wip: true do
  describe '#url' do
    it 'uses sandbox api by default' do
      @api = WeeAgent::API.new(access_token: 'test_access_token')

      expect(@api.url).to eq('https://api.sandbox.freeagent.com/v2')
    end

    it 'uses the live api if given explicit option' do
      @api = WeeAgent::API.new(access_token: 'test_access_token', environment: :production)

      expect(@api.url).to eq('https://api.freeagent.com/v2')
    end
  end
end
