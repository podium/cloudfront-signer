# CloudfrontSigner

Elixir implementation of Cloudfront's url signature algorithm. Supports expiration policies and
runtime configurable distributions. Fork of https://github.com/Frameio/cloudfront-signer

## Installation

The patched package can be installed
by adding `cloudfront_signer` to your list of dependencies in `mix.exs` as a git based dependency:

```elixir
def deps do
  [
    {:cloudfront_signer, github: "johnmcguin/cloudfront-signer", ref: "320990b662218a922e510f390f6fad81ee1271e8"},
  ]
end
```

Consult the [mix documentation for git based dependencies](https://hexdocs.pm/mix/1.16.0/Mix.Tasks.Deps.html) for valid syntax options.

Configure a distribution with:

```elixir
config :my_app, :my_distribution,
  domain: "https://some.cloudfront.domain",
  private_key: {:system, "ENV_VAR"}, # or {:file, "/path/to/key"}
  key_pair_id: {:system, "OTHER_ENV_VAR"}
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
