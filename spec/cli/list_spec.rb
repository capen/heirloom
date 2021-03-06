require 'spec_helper'
require 'heirloom/cli'

describe Heirloom do

  before do
    @options = { :name            => 'archive_name',
                 :level           => 'info',
                 :metadata_region => 'us-west-1',
                 :count           => 100 }
    @logger_stub = stub :debug => true
    @config_mock = mock 'config'
    @archive_mock = mock 'archive'
    @config_mock.stub :logger          => @logger_mock, 
                      :access_key      => 'key',
                      :secret_key      => 'secret',
                      :metadata_region => 'us-west-1'
    Heirloom::HeirloomLogger.should_receive(:new).with(:log_level => 'info').
                             and_return @logger_stub
    Heirloom::CLI::List.any_instance.should_receive(:load_config).
                        with(:logger => @logger_stub,
                             :opts   => @options).
                        and_return @config_mock
    Heirloom::Archive.should_receive(:new).
                      with(:name => 'archive_name',
                           :config => @config_mock).
                      and_return @archive_mock
    Heirloom::Archive.should_receive(:new).
                      with(:name   => 'archive_name',
                           :config => @config_mock).
                      and_return @archive_mock
    @archive_mock.should_receive(:domain_exists?).and_return true
    @archive_mock.should_receive(:count)
  end

  context "as json" do
    before do
      @options[:json] = true
      Trollop.stub :options => @options
    end

    it "should list ids for given archive" do
      @cli_list = Heirloom::CLI::List.new
      @archive_mock.should_receive(:list).with(100).and_return(['1','2'])
      @cli_list.should_receive(:jj).with ['1','2']
      @cli_list.list
    end
  end

  context "as human readable" do
    before do
      @options[:json] = nil
      Trollop.stub :options => @options
    end

    it "should list ids for given archive" do
      @cli_list = Heirloom::CLI::List.new
      @archive_mock.should_receive(:list).with(100).and_return(['1','2'])
      @cli_list.should_receive(:puts).with "1\n2"
      @cli_list.list
    end
  end

end
