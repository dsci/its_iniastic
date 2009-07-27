require File.dirname(__FILE__) + '/spec_helper'

class TestIni < ActiveIni::Base
  property :sms_gateway
  property :e2sGw
  property :port
  
  comment "#"
  parameter "="
  path "/vendor/plugins/its_iniastic/tmp/test.ini"
end

describe ItsIniastic, "Properties and loading functionality" do
  
  before(:each) do
    @test = TestIni.new
  end
  
  it "should have a sms setter and getter method" do
    @test.methods.include?("sms_gateway").should be true
    @test.methods.include?("sms_gateway=").should be true
  end
  
  it "should have a delimeter method" do
    @test.methods.include?("comment")
  end
  
  it "should return an instance of itself if load class method is called" do
    @loaded = TestIni.load
    @loaded.is_a?(TestIni)
    @loaded.port.should == "30201"
    @loaded.e2sGw.should == "info@datenspiel.com"
    #@loaded.is_a?(Hash).should be true
    #@loaded.has_key?(:debugFile).should be true
    #@loaded.values_at(:port).to_s.should == "30201"
  end
  
end

describe ItsIniastic, "Writing ini files" do
  
  before(:each) do
    @test = TestIni.new
  end
  
  it "should have an array of properties" do
    @test.properties.should_not be nil
    @test.properties.include?(:port).should be true
  end
  
  it "should write the ini file" do
    @loaded = TestIni.load
    @loaded.port = 8080
    @loaded.save.should be true
  end
end