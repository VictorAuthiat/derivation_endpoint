### CarrierWave example

**Create initializer**

```ruby
DerivationEndpoint.configure do |config|
  config.host   = "http://localhost:3000"
  config.prefix = "derivation_endpoints"

  config.encoder = ->(method_value) { method_value.file.path }
  config.decoder = ->(path, options) do
    uploader = options[:uploader].constantize
    storage  = CarrierWave::Storage::AWS.new(uploader)

    CarrierWave::Storage::AWSFile.new(uploader, storage.connection, path).url
  end
end
```

**Mount derivation endpoint.**

```ruby
mount DerivationEndpoint::Derivation.new => DerivationEndpoint.derivation_path
```

**Update model**

```ruby
class Post < ApplicationRecord
  extend DerivationEndpoint

  mount_uploader :file, FileUploader

  derivation_endpoint :file, options: { uploader: FileUploader }
end
```
