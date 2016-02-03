require 'spec_helper'

describe WebhookSystem, aggregate_failures: true, db: true do
  describe 'creating and finding subscriptions' do
    let(:subscription1) { create(:webhook_subscription, :active) }

    before do
      subscription1.topics.create!(name: 'one')
      subscription1.topics.create!(name: 'two')
    end

    let(:subscription2) { create(:webhook_subscription, :active) }

    before do
      subscription2.topics.create!(name: 'two')
      subscription2.topics.create!(name: 'three')
    end

    let(:subscription3) { create(:webhook_subscription) }

    before do
      subscription3.topics.create!(name: 'one')
      subscription3.topics.create!(name: 'two')
      subscription3.topics.create!(name: 'three')
    end

    it 'properly finds those subscriptions' do
      expect(WebhookSystem::Subscription.interested_in_topic('one')).to match_array([subscription1])
      expect(WebhookSystem::Subscription.interested_in_topic('two')).to match_array([subscription1, subscription2])
      expect(WebhookSystem::Subscription.interested_in_topic('three')).to match_array([subscription2])
    end
  end
end
