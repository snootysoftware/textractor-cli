Given(/^pry$/) do
  require 'pry'; binding.pry
  puts "done"
end

Given(/^the endpoint "([^"]*)" returns this content:$/) do |path, input|
  inputhash = JSON.parse(input)
  RubyMock.resources[path + '/' + inputhash.keys.first] = input
end

Then(/^the following request body should have been sent:$/) do |string|
  RubyMock.requests.map {|n| JSON.parse(n) }.should include(JSON.parse string)
end
