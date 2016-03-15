require 'spec_helper'

describe WeeAgent::InvoiceBuilder do
  describe '#create_free_agent_invoice' do
    before do
      # Oauth::Authentication.make!(:freeagent)
    end

    it 'should send a request to free agent to create an invoice' do
      VCR.use_cassette('create_free_agent_invoice') do
        # expect(invoice.create_free_agent_invoice).to_not be nil
      end
    end
  end

  describe '#items' do
    let(:main_item) {
      {
        :description => invoice.summary,
        :item_type => 'Training',
        :price => 100,
        :quantity => 1
      }
    }

    let(:accommodation_item) {
      {
        :description => "Accommodation",
        :item_type => 'Services',
        :price => WeGotCoders.accommodation_cost,
        :quantity => 1
      }
    }

    describe 'should change in length depending on accommodation' do
      context 'with accomodation' do
        before { invoice.application.accommodation_required = true }
        context do
          before { invoice.custom = false }
        end

        it 'should be added as an item when not custom' do
          expect(invoice.send(:items).length).to eq 2
        end

        it 'should format the items correctly' do
          expect(invoice.send(:items)).to eq [main_item, accommodation_item]
        end

        it 'should not be added when custom' do
          invoice.custom = true
          expect(invoice.send(:items).length).to eq 1
        end
      end
      context 'without accommodation' do
        before {invoice.application.accommodation_required = false }
        it 'should be just one if accommodation is not needed' do
          expect(invoice.send(:items).length).to eq 1
        end

        it 'should format the items correctly' do
          expect(invoice.send(:items)).to eq [main_item]
        end
      end
    end
  end
end
