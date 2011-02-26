require 'spec_helper'

describe Pumpkin::Content do
  let(:root) { Pumpkin::Content.create!(:node_id => "Root") }
  
  it "should get the root node" do
    root.root?.should be_true
    Pumpkin::Content.root.should eq(root)
  end

  context "in a document tree" do
    before(:each) do
      @child_1 = Pumpkin::Content.create!(:node_id => "Child_1", :parent => root)
      @child_2 = Pumpkin::Content.create!(:node_id => "Child_2", :parent => root)
      @child_2_1 = Pumpkin::Content.create!(:node_id => "Child_2_1", :parent => @child_2)
    end

    it "the root node should not have a parent" do
      root.descendant_of?(@child_1).should_not be_true
      root.descendant_of?(@child_2_1).should_not be_true
    end

    it "all nodes should be descendant of root" do
      @child_1.descendant_of?(root).should be_true
      @child_2_1.descendant_of?(root).should be_true
      root.descendants.should include(@child_1,@child_2,@child_2_1)
    end
  end

  context "when creating a node" do
    it "should not allow two siblings to have the same node_id" do
      Pumpkin::Content.create!(:node_id => "Child_1", :parent => root)
      Pumpkin::Content.create!(:node_id => "Child_2", :parent => root)
      expect { Pumpkin::Content.create!(:node_id => "child_1", :parent => root) }.to raise_error(MongoMapper::DocumentNotValid)
    end
  
    it "should allow to have dynamic attributes" do
      content = Pumpkin::Content.create!(:node_id => "Child1", :name => "Damian", :age => 26, :gender => "male", :photo_filename => "/tmp/clock.png", :parent => root)
      content.reload.name.should eq("Damian")
      content.age.should eq(26)
      content.gender.should eq("male")
    end
  end
end
