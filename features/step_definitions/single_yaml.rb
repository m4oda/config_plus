$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'config_plus'

Before do
  @root_dir = File.expand_path('../../works', __FILE__)
  Dir.mkdir(@root_dir) unless Dir.exist?(@root_dir)
end

After do
  if Dir.exist?(@root_dir)
    filenames = Dir.entries(@root_dir).select {|filename|
      filename != '.' && filename != '..'
    }.map {|filename|
      File.join(@root_dir, filename)
    }

    File.delete(*filenames)
    Dir.rmdir(@root_dir)
  end
end

Given(/^a YAML file named `([^']*)' with data:$/) do |filename, string|
  open(File.join(@root_dir, filename), 'w') do |f|
    f.write(string)
  end
end

When("we add a code block for setting:") do |string|
  block = lambda {|config| eval(string) }
  ConfigPlus.configure(&block)
end

Then("ConfigPlus.root has data") do
  expect(ConfigPlus.root).not_to be_nil
end

Then(/^ConfigPlus.([^\s]*) has a key `([^']*)'$/) do |namechain, keyname|
  value = namechain.split('.').inject(ConfigPlus) do |obj, name|
    obj.__send__(name)
  end
  expect(value).to have_key(keyname)
end

Then(/^ConfigPlus.([^\s]*) returns a string `([^']*)'$/) do |namechain, string|
  value = namechain.split('.').inject(ConfigPlus) do |obj, name|
    obj.__send__(name)
  end
  expect(value).to eq(string)
end

Then(/^ConfigPlus.([^\s]*) returns an array data$/) do |namechain|
  value = namechain.split('.').inject(ConfigPlus) do |obj, name|
    obj.__send__(name)
  end
  expect(value).to be_an_instance_of(Array)
end
