require 'dummy_spec_helper'

describe "" do
  it "truth" do
    Rails.application.should be_kind_of(Dummy::Application)
  end
end
