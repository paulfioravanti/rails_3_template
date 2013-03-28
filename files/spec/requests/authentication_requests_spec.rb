require 'spec_helper'

describe "Authentication Requests" do

  subject { response }

  # I18n.available_locales.each do |locale|

  describe "authorization" do
    context "for signed-in users" do
      let(:user) { create(:user) }

      before { sign_in_request(user) }

      context "GET Users#new" do
        before { get register_path }
        it { should redirect_to(root_url) }
      end

      context "POST Users#create" do
        before { post users_path }
        it { should redirect_to(root_url) }
      end
    end
  end

end