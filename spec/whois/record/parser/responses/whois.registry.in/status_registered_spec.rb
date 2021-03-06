# encoding: utf-8

# This file is autogenerated. Do not edit it manually.
# If you want change the content of this file, edit
#
#   /spec/fixtures/responses/whois.registry.in/status_registered.expected
#
# and regenerate the tests with the following rake task
#
#   $ rake genspec:parsers
#

require 'spec_helper'
require 'whois/record/parser/whois.registry.in.rb'

describe Whois::Record::Parser::WhoisRegistryIn, "status_registered.expected" do

  before(:each) do
    file = fixture("responses", "whois.registry.in/status_registered.txt")
    part = Whois::Record::Part.new(:body => File.read(file))
    @parser = klass.new(part)
  end

  describe "#status" do
    it do
      @parser.status.should == %w( ok )
    end
  end
  describe "#available?" do
    it do
      @parser.available?.should == false
    end
  end
  describe "#registered?" do
    it do
      @parser.registered?.should == true
    end
  end
  describe "#created_on" do
    it do
      @parser.created_on.should == Time.parse("2005-02-14 20:35:14 UTC")
    end
  end
  describe "#updated_on" do
    it do
      @parser.updated_on.should == Time.parse("2009-04-06 18:20:09 UTC")
    end
  end
  describe "#expires_on" do
    it do
      @parser.expires_on.should == Time.parse("2011-02-14 20:35:14 UTC")
    end
  end
  describe "#registrar" do
    it do
      @parser.registrar.should be_a(Whois::Record::Registrar)
      @parser.registrar.id.should == "R84-AFIN"
      @parser.registrar.name.should == "Mark Monitor"
    end
  end
  describe "#nameservers" do
    it do
      @parser.nameservers.should be_a(Array)
      @parser.nameservers.should have(4).items
      @parser.nameservers[0].should be_a(_nameserver)
      @parser.nameservers[0].should == _nameserver.new(:name => "ns1.google.com")
      @parser.nameservers[1].should be_a(_nameserver)
      @parser.nameservers[1].should == _nameserver.new(:name => "ns2.google.com")
      @parser.nameservers[2].should be_a(_nameserver)
      @parser.nameservers[2].should == _nameserver.new(:name => "ns3.google.com")
      @parser.nameservers[3].should be_a(_nameserver)
      @parser.nameservers[3].should == _nameserver.new(:name => "ns4.google.com")
    end
  end
end
