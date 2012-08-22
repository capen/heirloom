require 'spec_helper'

describe Heirloom::Builder do
  before do
    @config_mock   = double 'config'
    @logger_stub   = stub :debug => 'true', :info => 'true', :warn => 'true'
    @config_mock.stub(:logger).and_return(@logger_stub)
    @builder       = Heirloom::Builder.new :config => @config_mock,
                                           :name   => 'tim',
                                           :id     => '123'
    @directory_mock = mock 'directory'
    Heirloom::Directory.should_receive(:new).
                        with(:path    => 'path_to_build',
                             :exclude => ['.dir_to_exclude'],
                             :config  => @config_mock).
                        and_return @directory_mock
  end

  context 'when successful' do
    it "should build an archive" do
      @directory_mock.should_receive(:build_artifact_from_directory).
                      with(:secret => 'secret').
                      and_return true
      @directory_mock.should_receive(:local_build).
                      and_return '/var/tmp/file.tar.gz'
      @builder.build(:exclude   => ['.dir_to_exclude'],
                     :directory => 'path_to_build',
                     :base      => 'the_base',
                     :secret    => 'secret').should == '/var/tmp/file.tar.gz'
    end

  end

  context 'when unsuccessful' do
    it "should return false if the build fails" do
      @directory_mock.stub :build_artifact_from_directory => false
      @builder.build(:exclude   => ['.dir_to_exclude'],
                     :directory => 'path_to_build',
                     :base      => 'the_base',
                     :secret    => 'secret').should be_false
    end
  end
end
