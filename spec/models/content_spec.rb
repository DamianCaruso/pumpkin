require 'spec_helper'

describe Pumpkin::Content do  
  before(:each) { @root = Pumpkin::Content.create!(:node_id => "Root") }
  
  describe "#root" do
    subject { Pumpkin::Content.root }
    it { should eq(@root) }
  end

  describe "#create" do
    context "when root node is created" do
      subject { @root }
      its(:depth) { should eq(0) }
    end
    
    context "when a node is created" do
      subject { Pumpkin::Content.create!(:node_id => "Child_1", :parent => @root) }
      
      it { should be_valid }
      its(:depth) { should eq(1) }
      it "should be descendant_of root" do
        subject.descendant_of?(@root).should be_true
      end
    end
    
    context "when a sibling node is created" do
      before do
        Pumpkin::Content.create!(:node_id => "Child_1", :parent => @root)
      end
      
      it "should have an unique node_id" do
        expect { Pumpkin::Content.create!(:node_id => "child_1", :parent => @root) }.to raise_error(MongoMapper::DocumentNotValid)
      end
    end
  end
  
  describe "#find_by_path" do
    before do
      @child_1 = Pumpkin::Content.create!(:node_id => "Child_1", :parent => @root)
      @child_1_1 = Pumpkin::Content.create!(:node_id => "Child_1_1", :parent => @child_1)
    end
    
    it "should return the node with the provided path" do
      node = Pumpkin::Content.find_by_path(["root","child_1","Child_1_1"])
      node.should eq(@child_1_1)
    end
  end
end
