defmodule CloudfrontSigner.DistributionRegistry do
  @moduledoc """
  Agent to store and fetch cloudfront distributions, to avoid expensive runtime pem decodes
  """
  use Agent

  alias CloudfrontSigner.Distribution

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Gets a distribution from the registry. If not found, creates it from config and caches it.
  """
  @spec get_distribution(atom(), atom()) :: Distribution.t()
  def get_distribution(scope, key) do
    Agent.get_and_update(
      __MODULE__,
      &Map.get_and_update(&1, {scope, key}, fn
        nil ->
          dist = Distribution.from_config(scope, key)
          {dist, dist}

        dist ->
          {dist, dist}
      end)
    )
  end
end
