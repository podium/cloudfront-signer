defmodule CloudfrontSigner do
  @moduledoc """
  Elixir implementation of cloudfront's signed url algorithm.  Basic usage is:

  ```
  CloudfrontSigner.Distribution.from_config(:scope, :key)
  |> CloudfrontSigner.sign("some/path", [arg: "val"], some_expiry)
  ```
  """
  alias CloudfrontSigner.Distribution
  alias CloudfrontSigner.Policy

  @doc """
  Signs a url for the given `Distribution.t` struct constructed from the `path` and `query_params` provided.  `expiry`
  is in seconds.
  """
  @spec sign(Distribution.t(), binary() | list() | map(), integer(), list()) :: binary()
  def sign(%Distribution{domain: domain, private_key: pk, key_pair_id: kpi}, path, expiry, query_params \\ []) do
    expiry =
      DateTime.utc_now()
      |> DateTime.add(expiry, :second)
      |> DateTime.to_unix()

    url =
      domain
      |> URI.merge(path)
      |> to_string()
      |> url(query_params)

    {signature, encoded_policy} =
      Policy.generate_signature_and_policy(%Policy{resource: url, expiry: expiry}, pk)

    aws_query = signature_params(encoded_policy, signature, kpi)
    signed_url(url, query_params, aws_query)
  end

  defp url(base, []), do: base
  defp url(base, ""), do: base
  defp url(base, query_params), do: base <> "?" <> prepare_query_params(query_params)

  defp signed_url(base, [], aws_query), do: base <> "?" <> aws_query
  defp signed_url(base, "", aws_query), do: base <> "?" <> aws_query
  defp signed_url(base, _params, aws_query), do: base <> "&" <> aws_query

  defp prepare_query_params(query_params) when is_binary(query_params), do: query_params

  defp prepare_query_params(query_params) when is_list(query_params) or is_map(query_params) do
    URI.encode_query(query_params)
  end

  defp signature_params(policy, signature, key_pair_id) do
    "Policy=#{policy}&Signature=#{signature}&Key-Pair-Id=#{key_pair_id}"
  end
end
