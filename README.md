ConfigPlus
==================================================

これは YAML ファイルから設定情報を読み込むためのライブラリです。
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

次のようにアクセスすることができます。

```
>> ConfigPlus.generate(from: '/path/to/configuration/file.yml')
>> ConfigPlus.root[:foo][:baa][:baz]
=> {"spam"=>123, "ham"=>"abc"}
>> ConfigPlus.root['foo']['baa']['baz']
=> {"spam"=>123, "ham"=>"abc"}
>> ConfigPlus.root.foo.baa.baz
=> {"spam"=>123, "ham"=>"abc"}
>> ConfigPlus.root.get('foo.baa.baz')
=> {"spam"=>123, "ham"=>"abc"}
```

自動マッピング
--------------------------------------------------
上記のような場合、もし YAML の構造と同じパスを持つ `Foo::Baa::Baz` というクラスがあれば、
次のようにして設定情報にアクセスすることができます。

```
>> module Foo
>>  module Baa
>>    class Baz
>>      include ConfigPlus
>>    end
>>  end
>> end
>> Foo::Baa::Baz.config
=> {"spam"=>123, "ham"=>"abc"}
>> Foo::Baa::Baz.config.spam
=> 123
>> baz = Foo::Baa::Baz.new
=> #<Foo::Baa::Baz0x00...>
>> baz.config.ham
=> "abc"
```

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

```
>> Sample::SettingA.config
=> {"spam"=>"spam-00", "ham"=>"ham-01", "egg"=>"egg-00"}
```

その他
--------------------------------------------------
設定ファイルへのパス以外の設定がある場合、次のようにブロックを使って記述します。

```
ConfigPlus.configure do |conf|
  conf.root_dir = Rails.root
  conf.source = 'config/config_plus'
  conf.namespace = Rails.env
  conf.loader = {extensions: '00.yml'}
  conf.config_method = :setting
end
```

各設定の意味は次のようになっています。

* `config_method`
  * `include ConfigPlus` で自動マッピングする時の、設定読み込みメソッドの名前です。デフォルトは `config`
* `loader`
  * `extensions`
    * `source` にディレクトリパスを指定した場合に、読み込むファイルの拡張子
  * `action`
    * 設定ファイルの読み込み処理
* `namespace`
  * 使用するネームスペース
* `root_dir`
  * `source` で指定するパスの親ディレクトリのパス
* `source`
  * 設定ファイル、またはそれが格納されているディレクトリのパス

ライセンス
--------------------------------------------------
++ConfigPlus++ は MIT License です。
