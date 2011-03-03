require 'spec_helper'

describe "content" do
  describe "GET resource" do
    describe "when found" do
      let(:content) { mock('Pumpkin::Content') }
      
      before(:each) do
        Pumpkin::Content.should_receive(:find_by_path).with(instance_of(Array)).once.and_return(content)
      end
      
      context "json response" do
        before(:each) do
          get '/route.json'
        end

        it { last_response.should be_ok }
        it { last_response.content_type.should eq("application/json") }
      end
      
      context "xml response" do
        before(:each) do          
          get '/route.xml'
        end

        it { last_response.should be_ok }
        it { last_response.content_type.should eq("application/xml;charset=utf-8") }
      end
    end
    
    describe "when not found" do
      before(:each) do
        Pumpkin::Content.should_receive(:find_by_path).with(instance_of(Array)).once.and_return(nil)
      end
      
      context "json request" do
        before(:each) do
          get '/route.json'
        end
        
        it { last_response.not_found?.should be_true }
      end
      
      context "xml request" do
        before(:each) do
          get '/route.xml'
        end
        
        it { last_response.not_found?.should be_true }
      end
    end
  end
end
