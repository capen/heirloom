require 'spec_helper'

describe Heirloom::MetadataAdder do

  before do
    @config_mock   = double 'config'
    @logger_stub   = stub :debug => 'true', :info => 'true', :warn => 'true'
    @config_mock.stub(:logger).and_return(@logger_stub)
    @simpledb_mock_west = mock 'simpledb'
    @simpledb_mock_east = mock 'simpledb'
    Heirloom::AWS::SimpleDB.should_receive(:new).
                            with(:config => @config_mock, 
                                 :region => 'us-west-1').
                        and_return @simpledb_mock_west
    Heirloom::AWS::SimpleDB.should_receive(:new).
                            with(:config => @config_mock, 
                                 :region => 'us-east-1').
                        and_return @simpledb_mock_east
    @metadata_adder = Heirloom::MetadataAdder.new :config => @config_mock,
                                                  :name   => 'tim',
                                                  :id     => '123'

  end

  context 'when successful' do
    it "should add metadata to simpledb in each zone specified" do
      @metadata_adder.stub :current_time => '00:00:00'
      attributes = { "base"       => "base", 
                     "created_at" => "00:00:00", 
                     "encrypted"  => true, 
                     "id"         => "123", 
                     "name"       =>"tim"}
      @simpledb_mock_west.should_receive(:put_attributes).
                          with "heirloom_tim", "123", attributes
      @simpledb_mock_east.should_receive(:put_attributes).
                          with "heirloom_tim", "123", attributes
      @metadata_adder.add_metadata :base      => 'base',
                                   :encrypted => true,
                                   :regions   => ['us-west-1', 'us-east-1']
    end

  end
end
