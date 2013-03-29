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

    describe "cookie handling" do
      let(:user) { create(:user) }

      subject { response.headers["Set-Cookie"] }

      context "when remember me is set" do
        before { sign_in_request(user) }
        it { should =~ %r(.+expires.+#{20.years.from_now.year}) }
      end

      context "when remember me is not set" do
        before { sign_in_request(user, remember_me: false) }
        it { should_not =~ %r(expires) }
      end
    end
  end

end