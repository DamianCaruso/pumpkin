require 'spec_helper'

describe "content" do
  describe "GET resource" do
    context "when found" do
      let(:node) { mock('Pumpkin::Content') }

      before(:each) do        
        Pumpkin::Content.should_receive(:find_by_path).with(instance_of(Array)).once.and_return(node)
        node.should_receive(:to_json).and_return({}.to_json)
        get '/'
      end

      it { last_response.should be_ok }
      it { last_response.content_type.should eq("application/json") }
    end
    
    context "when not found" do
      before(:each) do
        Pumpkin::Content.should_receive(:find_by_path).with(instance_of(Array)).once.and_return(nil)
        get '/'
      end

      it { last_response.not_found?.should be_true }
    end
  end
end
