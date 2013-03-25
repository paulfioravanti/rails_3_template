require 'spec_helper'

describe User do

  let(:user) { create(:user) }

  subject { user }

  specify "model attributes" do
    should respond_to(:name)
    should respond_to(:email)
    should respond_to(:password_digest)
    should respond_to(:authentication_token)
    should respond_to(:admin)
  end

  specify "accessible attributes" do
    should_not allow_mass_assignment_of(:password_digest)
    should_not allow_mass_assignment_of(:authentication_token)
    should_not allow_mass_assignment_of(:admin)
  end

  specify "virtual attributes/methods from has_secure_password" do
    should respond_to(:password)
    should respond_to(:password_confirmation)
    should respond_to(:authenticate)
  end

  describe "initial state" do
    it { should be_valid }
    it { should_not be_admin }
    # its(:authentication_token) { should_not be_blank }
  end

  describe "validations" do
    context "for name" do
      it { should validate_presence_of(:name) }
      it { should_not allow_value(" ").for(:name) }
      it { should ensure_length_of(:name).is_at_most(50) }
    end

    context "for email" do
      it { should validate_presence_of(:email) }
      it { should_not allow_value(" ").for(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }

      context "when email format is invalid" do
        invalid_email_addresses.each do |invalid_address|
          it { should_not allow_value(invalid_address).for(:email) }
        end
      end

      context "when email format is valid" do
        valid_email_addresses.each do |valid_address|
          it { should allow_value(valid_address).for(:email) }
        end
      end
    end

    context "for password" do
      it { should validate_presence_of(:password) }
      it { should ensure_length_of(:password).is_at_least(6) }
      it { should_not allow_value(" ").for(:password) }

      context "when password doesn't match confirmation" do
        it { should_not allow_value("mismatch").for(:password) }
      end
    end

    context "for password_confirmation" do
      it { should validate_presence_of(:password_confirmation) }
    end
  end

  describe "#authenticate from has_secure_password" do
    let(:found_user) { User.find_by_email(user.email) }

    context "with valid password" do
      it { should == found_user.authenticate(user.password) }
    end

    context "with invalid password" do
      let(:user_with_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_with_invalid_password }
      specify { user_with_invalid_password.should be_false }
    end
  end
end