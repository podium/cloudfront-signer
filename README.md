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

Consult the [mix documentation for git based dependencies](https://hexdocs.pm/mix/1.16.0/Mix.Tasks.Deps.html) for valid syntax options.

Configure a distribution with:

```elixir
config :my_app, :my_distribution,
  domain: "https://some.cloudfront.domain",
  private_key: System.get_env("PRIVATE_KEY"), # or {:file, "/path/to/key"}
  key_pair_id: System.get_env("KEY_PAIR_ID")
```

Then simply do:

```elixir
CloudfrontSigner.Distribution.from_config(:my_app, :my_distribution)
|> CloudfrontSigner.sign(path, [arg: "value"], expiry_in_seconds)
```

If you want to cache pem decodes (which is a wise choice), a registry of decoded distributions is available. Simply do:

```elixir
CloudfrontSigner.DistributionRegistry.get_distribution(:my_app, :my_distribution)
|> CloudfrontSigner.sign(path, [arg: "value], expiry)
```
