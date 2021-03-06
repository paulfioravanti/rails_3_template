require 'spec_helper'

describe "Authentication on UI" do

  subject { page }

  # I18n.available_locales.each do |locale|

  describe "signin page" do
    let(:heading)    { t('sessions.new.signin') }
    let(:page_title) { t('sessions.new.signin') }

    before { visit signin_path }

    it { should have_selector('h1', text: heading) }
    it { should have_title(page_title) }
  end

  describe "signin" do
    let(:user)       { create(:user) }
    let(:page_title) { t('sessions.new.signin') }
    let(:signin)     { t('sessions.new.signin') }
    let(:signout)    { t('layouts.header.signout') }

    before { visit signin_path }

    it { should have_title(page_title) }
    it { should_not have_link(signout, href: signout_path) }

    context "with invalid information" do
      let(:invalid) { t('flash.invalid_credentials') }

      before { click_button signin }

      it { should have_title(page_title) }
      it { should have_alert_message('error', invalid) }

      context "after visiting another page" do
        let(:home) { t('layouts.header.home') }
        before { click_link home }
        it { should_not have_alert_message('error') }
      end
    end

    context "with valid information" do
      let(:signin) { t('layouts.header.signin') }
      let(:heading) { t('pages.home_signed_in.heading') }
      let(:successful_signin) { t('flash.successful_signin') }

      before { sign_in_through_ui(user) }

      it { should have_alert_message('success', successful_signin) }
      it { should have_selector('h1', text: heading) }
      it { should have_link(signout, href: signout_path) }
      it { should_not have_link(signin, href: signin_path) }

      context "followed by signout" do
        let(:successful_signout) { t('flash.successful_signout') }

        before { click_link signout }

        it { should have_alert_message('success', successful_signout) }
        it { should have_link(signin) }
      end
    end
  end
end