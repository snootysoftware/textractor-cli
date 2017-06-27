Given(/^pry$/) do
  require 'pry'; binding.pry
  puts "done"
end

Given(/^the endpoint "([^"]*)" returns this content:$/) do |path, input|
  RubyMock.resources[path] = input
end
