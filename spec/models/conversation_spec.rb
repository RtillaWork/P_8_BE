require 'rails_helper'

RSpec.describe Conversation, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it "is valid with valid attributes" do
    expect(described_class.new({ is_active: true, task: FactoryBot.create(:task), user: FactoryBot.create(:user, :volunteer) })).to be_valid
  end

end
