require 'spec_helper'

describe GoCardless::Merchant do
  before :each do
    @app_id = 'abc'
    @app_secret = 'xyz'
    @client = GoCardless::Client.new(:app_id => @app_id, :app_secret => @app_secret)
    @client.access_token = 'TOKEN123 manage_merchant:123'
    @redirect_uri = 'http://test.com/cb'
  end

  index_methods = [:subscriptions, :pre_authorizations, :users, :payments, :bills]

  index_methods.each do |method|
    it "##{method} works correctly" do
      merchant = GoCardless::Merchant.new(@client)

      data = [{:id => 1}, {:id => 2}]
      stub_get(@client, data)

      merchant.send(method).should be_a Array
      merchant.send(method).length.should == 2
      merchant.send(method).zip(data).each do |obj,attrs|
        obj.class.to_s.should == "GoCardless::#{method.to_s.camelize.sub(/s$/, '')}"
        attrs.each { |k,v| obj.send(k).should == v }
      end
    end
  end
end

