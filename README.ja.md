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
ConfigPlus.root[:foo][:baa][:baz]
#=> {"spam"=>123, "ham"=>"abc"}

ConfigPlus.root['foo']['baa']['baz']
#=> {"spam"=>123, "ham"=>"abc"}

ConfigPlus.root.foo.baa.baz
#=> {"spam"=>123, "ham"=>"abc"}

ConfigPlus.root.get('foo.baa.baz')
#=> {"spam"=>123, "ham"=>"abc"}
```

メソッド風のアクセスには多少の制限があります。
キーがメソッド名として有効である必要があるのはもちろんのこと、private
メソッドも含めて既存のメソッド名と重複した場合は、既存のメソッドの方が有効になります。

`ConfigPlus.root` は `Hash` を拡張したオブジェクトなので、
おおよそ `Hash` のメソッドを上書きできない（正確には `ConfigPlus::Node`
のメソッドを上書きできない）、ということになります。

自動マッピング
--------------------------------------------------
YAML の構造と同じパスを持つクラス（上記の場合であれば `Foo::Baa::Baz` というクラス）がある場合、
次のようにして設定情報にアクセスすることもできます。

```ruby
module Foo
  module Baa
    class Baz
      include ConfigPlus
    end
  end
end

Foo::Baa::Baz.config
#=> {"spam"=>123, "ham"=>"abc"}

Foo::Baa::Baz.config.spam
#=> 123

baz = Foo::Baa::Baz.new
baz.config.ham
#=> "abc"
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
    spam: spam-00
    ham: ham-00
    egg: egg-00
```

```yml
# sample-01.yml
sample:
  setting_a:
    ham: ham-01
```

`sample-00.yml` がベースとなり、そこに `sample-01.yml` が上書きされて読み込まれます。

```ruby
Sample::SettingA.config
#=> {"spam"=>"spam-00", "ham"=>"ham-01", "egg"=>"egg-00"}
```

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

ライセンス
--------------------------------------------------
`ConfigPlus` は MIT ライセンスです。
