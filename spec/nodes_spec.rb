require_relative "spec_helper"
require_relative "../lib/nodes"

def app
  LeoTamer::Nodes.new
end

describe LeoTamer::Nodes do
  subject { @data }

  describe "/nodes/list.json" do
    before(:all) { get_json "/nodes/list.json" }

    it "returns valid format" do
      should be_a Hash
      should have_key "data"
      should have(1).items
      
      subject["data"].should be_a Array
      subject["data"].each do |node|
        node.should be_a Hash
        node.should have_key "name"
        node.should have(1).items
        node["name"].should be_a String
      end
    end
  end
  
  describe "/nodes/status.json" do
    Member = {
      type: String,
      node: String,
      status: String,
      ring_hash_current: String,
      ring_hash_previous: String,
      joined_at: String
    }
    
    before(:all) { get_json "/nodes/status.json" }

    it "returns valid format" do
      should be_a Hash
      should have_key "data"
      should have(1).items
      
      data = subject["data"]
      data.should be_a Array
      
      data.each do |node|
        node.should be_a Hash
        Member.each do |key, klass|
          key = key.to_s
          node.should have_key key
          node[key].should be_a klass
        end
      end
    end
  end

  describe "/nodes/detail.json" do

    context "no params" do
      it "raises Error" do
        lambda {
          get_json "/nodes/detail.json"
        }.should raise_error
      end
    end

    context "with params" do
      subject { @data["data"] }

      before do
        get_json "/nodes/detail.json",
                 :node => "storage_0@127.0.0.1"
      end

      it "returns node detail status" do
        should be_a Array
        subject.each do |kv|
          kv.should be_a Hash
          kv.should have_key "name"
          kv.should have_key "value"
        end
      end
    end
  end
end
