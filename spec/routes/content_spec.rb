require 'spec_helper'

describe "GET /" do
  it "should respond OK" do
    get '/'
    last_response.should be_ok
  end
end
