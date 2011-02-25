require 'spec_helper'

describe Pumpkin::Content do
  let(:root) { Pumpkin::Content.create!(:node_id => "Root") }
  
  it "should not allow two nodes from same parent to have the same node_id" do
    Pumpkin::Content.create!(:node_id => "Child1", :parent => root)
    Pumpkin::Content.create!(:node_id => "Child2", :parent => root)
    expect { Pumpkin::Content.create!(:node_id => "Child1", :parent => root) }.to raise_error(MongoMapper::DocumentNotValid)
  end
  
  it "should allow to create dynamic attributes" do
    content = Pumpkin::Content.create!(:node_id => "Child1", :name => "Damian", :age => 26, :gender => "male", :photo_filename => "/tmp/clock.png", :parent => root)
    content.reload.name.should eq("Damian")
    content.age.should eq(26)
    content.gender.should eq("male")
  end
end
