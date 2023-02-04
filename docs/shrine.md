## Shrine example

**Create initializer**

```ruby
DerivationEndpoint.configure do |config|
  config.host    = "http://localhost:3000"
  config.prefix  = "derivation_endpoints"
  config.encoder = ->(method_value) { method_value.id }
  config.decoder = ->(path, options) { Shrine::UploadedFile.new(id: path, storage: options[:storage]).url }
end
```

**Mount derivation endpoint**

```ruby
mount DerivationEndpoint::Derivation.new => DerivationEndpoint.derivation_path
```

**Update model**

```ruby
class Post < ApplicationRecord
  extend DerivationEndpoint

  derivation_endpoint :file, options: { storage: :store }
end
```
