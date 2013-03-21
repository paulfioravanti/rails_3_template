require 'spec_helper'

describe ApplicationHelper do
  describe "#full_title" do
    I18n.available_locales.each do |locale|
      context "with page name" do
        let(:page_name) { 'foo' }
        let(:base_name) { t('layouts.application.base_title') }

        subject { full_title(page_name) }

        before { I18n.locale = locale }

        it { should =~ /#{page_name}/ }
        it { should =~ /^#{base_name}/ }
      end
    end
  end

  context "without page name" do
    let(:bar) { '|' }
    subject { full_title("") }
    it { should_not =~ /\#{bar}/ }
  end
end