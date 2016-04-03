ConfigPlus
============================================================

An easy-to-use, powerful configuration module using YAML files
for Ruby.


Simple Usage
------------------------------------------------------------
Add a configuration file in YAML format in your project:

```yml
foo:
  baa:
    baz:
      spam: 123
      ham: abc
```

You can access the configuration values with `ConfigPlus.root`:

```ruby
ConfigPlus.generate(from: '/path/to/configuration/file.yml')
ConfigPlus.root.foo.baa.baz.spam
#=> 123

ConfigPlus.root['foo']['baa']['baz']['spam']
#=> 123

ConfigPlus.root[:foo][:baa][:baz][:spam]
#=> 123

ConfigPlus.root.get('foo.baa.baz.spam')
#=> 123
```

`ConfigPlus` recurses a file tree looking for configuration files
when you specify a directory path at `ConfigPlus.generate from:`.

```ruby
ConfigPlus.generate(from: '/path/to/configuration/directory')
```

And you can specify some pathes using an array.

```ruby
ConfigPlus.generate(from: ['/path/to/directory1', '/path/to/file1.yml'])
```


Auto Mapping
------------------------------------------------------------
When data structure of loaded YAML and class structure of your
Ruby project have the same hierarchy, accessing the configuration
can be more simple:

```yml
fizz:
  buzz:
    spam: bacon
    ham: sausage
```

```ruby
ConfigPlus.generate(from: '/path/to/configuration/file.yml')

module Fizz
  class Buzz
    include ConfigPlus
  end
end

Fizz::Buzz.config.ham
#=> "sausage"

buzz = Fizz:Buzz.new
buzz.config.spam
#=> "bacon"
```


Overwrite Merge
------------------------------------------------------------
`ConfigPlus` loads the specified configuration files in file
name order and merge all of configuration into a single hash.

```yml
# sample-00.yml

sample:
  setting_a:
    spam: bacon
    ham: sausage
    egg: baked beans
```

```yml
# sample-01.yml

sample:
  setting_a:
    ham: spam
```

```ruby
Sample::SettingA.config
#=> {"spam"=>"bacon", "ham"=>"spam", "egg"=>"baked beans"}
```


Others
------------------------------------------------------------
Settings of `ConfigPlus` can be changed by the following way:

```ruby
ConfigPlus.configure do |conf|
  conf.root_dir      = Rails.root
  conf.source        = 'config/config_plus'
  conf.config_method = :setting
  conf.extension     = [:yml, :yaml]
  conf.namespace     = Rails.env
end
```

`configure` method works in a similar way as `generate` method.
Properties you can set are following:

* `config_method`
  * a method name to access configuration using in a class
    which does `include ConfigPlus`
* `extension`
  * extensions of configuration files which you allow to be
    loaded when you specify a directory path as `source`
* `namespace`
  * load configuration only from a tree of which first
    hierarchy key name is matched with the specified name
* `root_dir`
  * used as a parent directory path when you specify a
    relative path as `source`
* `source`
  * a file path or a directory path or an array of them


License
------------------------------------------------------------
MIT License
