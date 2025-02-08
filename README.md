# CloudfrontSigner

Elixir implementation of Cloudfront's url signature algorithm. Supports expiration policies and
runtime configurable distributions. Fork of https://github.com/Frameio/cloudfront-signer

## Installation

Add `cloudfront_signer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cloudfront_signer, "~> 0.2.0"}
  ]
end
```

## Configuring a Distribution

Configure a distribution with:

```elixir
config :my_app, :my_distribution,
  domain: "https://some.cloudfront.domain",
  private_key: System.get_env("PRIVATE_KEY"), # or {:file, "/path/to/key"}
  key_pair_id: System.get_env("KEY_PAIR_ID")
```

## Signing a URL without Caching PEM Decodes

Caching PEM decodes is a wise choice, but if you don't want to cache them, you can do the following:

```elixir
CloudfrontSigner.Distribution.from_config(:my_app, :my_distribution)
|> CloudfrontSigner.sign(path, [arg: "value"], expiry_in_seconds)
```

## Caching PEM Decodes

If you want to cache PEM decodes, you can use the distribution registry. 
Add `CloudfrontSigner.DistributionRegistry` to your application's supervision tree:

```elixir
# In your application.ex
def start(_type, _args) do
  children = [
    # ... other children ...
    CloudfrontSigner.DistributionRegistry
  ]

  opts = [strategy: :one_for_one, name: YourApp.Supervisor]
  Supervisor.start_link(children, opts)
end
```

Then use it like:

```elixir
CloudfrontSigner.DistributionRegistry.get_distribution(:my_app, :my_distribution)
|> CloudfrontSigner.sign(path, [arg: "value"], expiry)
```
