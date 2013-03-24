require 'spec_helper'

describe "Pages on UI" do

  subject { page }

  shared_examples_for "a static page" do
    it { should have_selector('h1', text: heading) }
    its(:source) { should have_selector('title', text: page_title) }
  end

  shared_examples_for "a layout link" do
    its(:source) { should have_selector('title', text: page_title) }
  end

  # I18n.available_locales.each do |locale|

  describe "Layout" do
    before { visit root_path }

    describe "Home link" do
      let(:page_title) { full_title('') }
      let(:home)       { t('layouts.header.home') }

      before { click_link home }

      it_should_behave_like "a layout link"
    end
  end

  describe "Home page" do
    let(:heading)    { t('layouts.header.<%= app_name %>') }
    let(:page_title) { full_title('') }
    let(:home)       { t('layouts.header.home') }

    before { visit root_path }

    it_should_behave_like "a static page"
    its(:source) { should_not have_selector('title', text: "| #{home}") }
  end
  # end
end