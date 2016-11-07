require 'spec_helper'

RSpec.describe Sufia::Workflow::CompleteNotification do
  let(:work) { instance_double(GenericWork, title: ["this"]) }
  let(:entity) { instance_double(Sipity::Entity, id: 9999, proxy_for: work, proxy_for_global_id: "123", updated_at: "today") }
  let(:user) { User.new }

  let(:depositor) { class_double(User, email: "xyz@def.com") }

  let(:userA) { instance_double(User, email: "abc@def.com") }
  let(:userB) { instance_double(User, email: "123@456.com") }

  let(:recipients) { { "to" => [userA], "cc" => [userB] } }
  let(:comment) { double("comment", comment: 'A pleasant read') }

  describe ".send_notification" do
    it 'sends messages to all users' do
      allow(ActiveFedora::Base).to receive(:find).with("123") { work }
      allow(::User).to receive(:find_by).with(hash_including(email: 'xyz@def.com')) { depositor }

      expect(userA).to receive(:send_message)
      expect(userB).to receive(:send_message)

      described_class.send_notification(entity: entity,
                                        user: user,
                                        comment: comment,
                                        recipients: recipients)
    end
  end
end