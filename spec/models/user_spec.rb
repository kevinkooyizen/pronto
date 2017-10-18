require 'rails_helper'

RSpec.describe User, type: :model do

  context "validations" do

    # happy_path
    describe "can be created when all attributes are present" do
      When(:user) { User.create(
        full_name: "Bob",
        email: "Bob@example.com",
        password: "123456",
        password_confirmation: "123456"
      )}
      Then { user.valid? == true }
    end

    # unhappy_path
    describe "cannot be created without a name" do
      When(:user) { User.create(email: "bob@example.com", password: "123456", password_confirmation: "123456") }
      Then { user.valid? == false }
    end

    describe "cannot be created without a email" do
      When(:user) { User.create(full_name: "Bob Koo", password: "123456", password_confirmation: "123456") }
      Then { user.valid? == false }
    end

    describe "cannot be created without a password" do
      When(:user) { User.create(full_name: "Bob", email: "bob@example.com") }
      Then { user.valid? == false }
    end

    describe "should permit valid email only" do
      let(:user1) { User.create(full_name: "Bob", email: "bob@example.com", password: "123456", password_confirmation: "123456")}
      let(:user2) { User.create(full_name: "Bob", email: "bob.com", password: "123456", password_confirmation: "123456") }

      # happy_path
      it "sign up with valid email" do
        expect(user1).to be_valid
      end

      # unhappy_path
      it "sign up with invalid email" do
        expect(user2).to be_invalid
      end
    end
  end

  context "associations" do

    describe User, '#initials' do
      let(:user) { User.create(full_name: "Bob The Builder", email: "bob@example.com", password: "123456", password_confirmation: "123456")}

      it "returns users initials" do
        expect(user.initials).to eq 'BTB'
      end
    end

    describe "finding paid users" do
      let(:paid_user) { User.create(full_name: "Bob", email: "bob@example.com", password: "123456", password_confirmation: "123456", paid: true)}
      let(:un_paid_user) { User.create(full_name: "Bob", email: "bob@example.com", password: "123456", password_confirmation: "123456", paid:false)}
      it 'returns only paid users' do
        result = User.where(paid: true)

        expect(result).to eq [paid_user]
      end
    end
  end

end
