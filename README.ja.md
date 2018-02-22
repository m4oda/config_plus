ConfigPlus
==================================================

`ConfigPlus` は YAML ファイルから設定情報を読み込むためのライブラリです。
読み込みたい YAML ファイルのパスを指定すると、`ConfigPlus.root` から設定情報にアクセスできるようになります。

基本的な使用例
--------------------------------------------------
例として、次のような YAML ファイルがあるとすると、

```yaml
foo:
  baa:
    baz:
      spam: 123
      ham: abc
```

次のようにアクセスできます。

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

なお、`ConfigPlus.generate from:` にディレクトリパスを指定すると、
指定したディレクトリを再帰的に検索して YAML ファイルを読み込みます。

```ruby
ConfigPlus.generate(from: '/path/to/configuration/directory')
```

ディレクトリパスやファイルパスを複数指定する場合は配列を使います。

```ruby
ConfigPlus.generate(from: ['/path/to/directory1', '/path/to/file1.yml'])
```

ERB タグを含む YAML の読み込み
--------------------------------------------------
`loader_logic` に `erb_yaml` を指定すると、ERB タグを解釈して読み込むことができます。

たとえばこのような YAML ファイルがあった場合、

```yaml
abc:
  foo: <%= (1..10).inject(&:+) %>
```

次のようになります。

```ruby
ConfigPlus.generate(from: 'path/to/configuration/file.erb.yml', loader_logic: :erb_yaml)
ConfigPlus.abc.foo
#=> 55
```

自動マッピング
--------------------------------------------------
YAML の構造と同じパスを持つクラスがある場合、
次のようにして設定情報にアクセスすることもできます。

```yaml
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

buzz = Fizz::Buzz.new
buzz.config.spam
#=> "bacon"
```

`ConfigPlus` を `include` することで、クラスメソッドとインスタンスメソッドに
`config` というメソッドが追加されます（このメソッド名は設定で変更できます）。
そこから、読み込んだ設定情報にアクセスできるようになります。

上書きマージ
--------------------------------------------------
`ConfigPlus` に読み込ませるパスには、ディレクトリを指定することもできます。
ディレクトリを指定した場合は、サブディレクトリも含めてファイルが探索され、
その中から拡張子がマッチしたものが全て読み込まれます。
読み込まれた YAML は、最終的に一つにマージされた Hash となります。

設定ファイルはファイル名でソートされた上で読み込まれ、マージされます。
このため、同じ設定情報があればソート順の大きい方で上書きされます。

例として、次のようなファイルが同じディレクトリに配置されていたとすると、

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

`sample-00.yml` がベースとなり、そこに `sample-01.yml` が上書きされて読み込まれます。

```ruby
Sample::SettingA.config
#=> {"spam"=>"bacon", "ham"=>"spam", "egg"=>"baked beans"}
```

個別ロード
--------------------------------------------------
`ConfigPlus` の基本動作では、指定された設定ファイル群の情報を `ConfigPlus.root`
に読み込みます。つまり、すべての情報は基本的にひとつのオプジェクトで管理されます。

これはシンプルな方法ですが、個別に読み込み、管理したいということもあるかもしれません。
次のようにすると、個別に設定情報を持たせることができます。

```ruby
class Foo
  extend ConfigPlus::Single
  generate_config '/path/to/configuration/file.yml', as: :conf
end

Foo.conf[:foo]
# => foo の値

ConfigPlus.root
# => nil
```

オプションの `as` で設定情報にアクセスするメソッド名を指定できます。
省略すると `config` が使われます。

その他
--------------------------------------------------
`ConfigPlus` の動作は設定で変更できます。
設定ファイルへのパス以外の設定がある場合、次のようにブロックを使って記述します。

```ruby
ConfigPlus.configure do |conf|
  conf.root_dir      = Rails.root
  conf.source        = 'config/config_plus'
  conf.config_method = :setting
  conf.extension     = '00.yml'
  conf.namespace     = Rails.env
end
```

`configure` メソッドは `generate` とほぼ同じ処理をするので、上記のように書けば改めて `generate` する必要はありません。

主な設定を簡単に説明すると、次のようになります。

| 設定            | 概要説明                                                             | 初期値            |
| --------------- | -------------------------------------------------------------------- | ----------------- |
| `config_method` | `include ConfigPlus` で自動マッピングした際の設定読み込みメソッド名  | `config`          |
| `extension`     | 読み込むファイルの拡張子。`source` がディレクトリの場合に有効        | `['yml', 'yaml']` |
| `namespace`     | 使用するネームスペース                                               |                   |
| `root_dir`      | `source` で指定するパスの親ディレクトリのパス                        |                   |
| `source`        | 設定ファイル、またはそれが格納されているディレクトリのパス           |                   |
| `loader_logic`  | 設定ファイルの読み込みロジックの設定                                 | `default`         |

ライセンス
--------------------------------------------------
`ConfigPlus` は MIT ライセンスです。
