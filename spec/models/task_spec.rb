require 'rails_helper'

RSpec.describe Task, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  subject {
    described_class.new({ title: 'T' * 60,
                          description: 'D' * 200,
                          kind: 'MN',
                          is_published: true,
                          unpublished_at: nil,
                          is_fullfilled: false,
                          lat: -23.4,
                          lng: -46.5,
                          created_at: Time.current,
                          updated_at: Time.current
                        })
  }

  it "is not valid without a title" do
    expect(described_class.new({ title: nil,
                                 description: 'D' * 200,
                                 kind: 'MN',
                                 is_published: true,
                                 unpublished_at: nil,
                                 is_fullfilled: false,
                                 lat: -23.4,
                                 lng: -46.5,
                                 created_at: Time.current,
                                 updated_at: Time.current
                               })).not_to be_valid
  end

  it "is not valid with a title longer than 64 characters" do
    expect(described_class.new({ title: 'T' * 65,
                                 description: 'D' * 200,
                                 kind: 'MN',
                                 is_published: true,
                                 unpublished_at: nil,
                                 is_fullfilled: false,
                                 lat: -23.4,
                                 lng: -46.5,
                                 created_at: Time.current,
                                 updated_at: Time.current
                               })).not_to be_valid
  end

  it "is not valid without a description" do
    expect(described_class.new({ title: 'T' * 60,
                                 description: nil,
                                 kind: 'MN',
                                 is_published: true,
                                 unpublished_at: nil,
                                 is_fullfilled: false,
                                 lat: -23.4,
                                 lng: -46.5,
                                 created_at: Time.current,
                                 updated_at: Time.current
                               })).not_to be_valid
  end

  it "is not valid with a description longer than 300 characters" do
    expect(described_class.new({ title: 'T' * 60,
                                 description: 'D' * 301,
                                 kind: 'MN',
                                 is_published: true,
                                 unpublished_at: nil,
                                 is_fullfilled: false,
                                 lat: -23.4,
                                 lng: -46.5,
                                 created_at: Time.current,
                                 updated_at: Time.current
                               })).not_to be_valid
  end

  it "is not valid without a latitude" do
    expect(described_class.new({ title: 'T' * 60,
                                 description: 'D' * 200,
                                 kind: 'MN',
                                 is_published: true,
                                 unpublished_at: nil,
                                 is_fullfilled: false,
                                 lat: nil,
                                 lng: -46.5,
                                 created_at: Time.current,
                                 updated_at: Time.current
                               })).not_to be_valid
  end

  it "is not valid without a longitude" do
    expect(described_class.new({ title: 'T' * 60,
                                 description: 'D' * 200,
                                 kind: 'MN',
                                 is_published: true,
                                 unpublished_at: nil,
                                 is_fullfilled: false,
                                 lat: -23.4,
                                 lng: nil,
                                 created_at: Time.current,
                                 updated_at: Time.current
                               })).not_to be_valid
  end

  it "is not valid without a user" do
    expect(described_class.new({ title: 'T' * 60,
                                 description: 'D' * 200,
                                 kind: 'MN',
                                 is_published: true,
                                 unpublished_at: nil,
                                 is_fullfilled: false,
                                 lat: -23.4,
                                 lng: -46.5,
                                 created_at: Time.current,
                                 updated_at: Time.current,
                                 user: nil })).not_to be_valid
  end

  # NOTE rails db:test:prepare

  it "is valid with valid attributes" do
    expect(described_class.new({ title: 'T' * 60,
                                 description: 'D' * 200,
                                 kind: 'MN',
                                 is_published: true,
                                 unpublished_at: nil,
                                 is_fullfilled: false,
                                 lat: -23.4,
                                 lng: -46.5,
                                 created_at: Time.current,
                                 updated_at: Time.current,
                                 user: FactoryBot.create(:user, :requestor) })).to be_valid
  end

end
