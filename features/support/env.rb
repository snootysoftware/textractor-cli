require 'aruba/cucumber'
require 'methadone/cucumber'
require 'webrick'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
LIB_DIR = File.join(File.expand_path(File.dirname(__FILE__)),'..','..','lib')

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @original_rubylib = ENV['RUBYLIB']
  ENV['RUBYLIB'] = LIB_DIR + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
end

AfterConfiguration do
	RubyMock.start
end

After do
  ENV['RUBYLIB'] = @original_rubylib
	RubyMock.clear
end

class RubyMock
  class << self; attr_accessor :resources end
  class << self; attr_accessor :requests end
  @resources = {}
  @requests = []

  def self.clear
    @requests = []
    @resources = {}
  end

  def self.start
    server = WEBrick::HTTPServer.new(Port: 8000, AccessLog: [], Logger: WEBrick::Log::new("/dev/null", 7))
    server.mount_proc '/' do |req, res|
      @requests << req.body
      res.body = @resources[req.path]
    end
    Thread.new do
      server.start
    end
  end
end
