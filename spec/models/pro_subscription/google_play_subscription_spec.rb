require 'rails_helper'

RSpec.describe ProSubscription::GooglePlaySubscription, type: :model do
  describe '#billing_service' do
    it 'should return :google_play' do
      ProSubscription::GooglePlaySubscription.new.billing_service
    end
  end

  it 'should cancel the subscription on destroy' do
    sub = ProSubscription::GooglePlaySubscription.create

    service = instance_double('GooglePlaySubscriptionService')
    allow(sub).to receive(:service).and_return(service)
    expect(service).to receive(:cancel).once

    sub.destroy
  end
end
