require 'spec_helper'

describe "Routing" do
  describe "root path" do
    subject { get("/") }
    it { should route_to("pages#home") }
  end
end