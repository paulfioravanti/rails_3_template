require 'spec_helper'

describe "User Pages on UI" do

  subject { page }

  shared_examples_for "a user page" do
    it { should have_selector('h1', text: heading) }
    its(:source) { should have_selector('title', text: page_title) }
  end

  # I18n.available_locales.each do |locale|

  describe "register page" do
    let(:heading)    { t('users.new.register') }
    let(:page_title) { full_title(t('users.new.register')) }

    before { visit register_path }

    it_should_behave_like "a user page"
  end

  describe "registration" do
    let(:submit) { t('users.new.create_account') }

    before { visit register_path }

    context "with invalid information" do

      describe "appearance" do
        let(:heading)    { t('users.new.register') }
        let(:page_title) { full_title(t('users.new.register')) }

        before { click_button submit }

        it_should_behave_like "a user page"
        it { should have_alert_message('error') }
      end

      describe "result" do
        subject { -> { click_button submit } }
        it { should_not change(User, :count) }
      end
    end

    context "with valid information" do
      let(:new_user) { build(:user) }

      before { fill_in_fields(new_user) }

      describe "appearance" do
        let(:successful_registration)  { t('flash.successful_registration') }
        let(:signout) { t('layouts.header.signout') }
        let(:heading) { t('pages.home_signed_in.heading') }
        let(:user) { User.find_by_email("#{new_user.email.downcase}") }

        before { click_button submit }

        # Redirect from registration page to signed in home page
        its(:source) { should have_selector('h1', text: heading) }
        it { should have_alert_message('success', successful_registration) }
        it { should have_link signout }
      end

      describe "result" do
        subject { -> { click_button submit } }
        it { should change(User, :count).by(1) }
      end
    end
  end

end