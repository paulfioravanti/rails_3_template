require 'spec_helper'

describe "Routing" do
  #I18n.available_locales.each do |locale|

  describe "root path" do
    subject { get("/") }
    it { should route_to("pages#home") }
  end

  describe "/signup routing" do
    subject { get("/register") }
    it { should route_to("users#new") }
  end

  describe "/signin routing" do
    subject { get("/signin") }
    it { should route_to("sessions#new") }
  end

  describe "/signout routing" do
    subject { delete("/signout") }
    it { should route_to("sessions#destroy") }
  end
end