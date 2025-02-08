defmodule CloudfrontSigner.DistributionRegistryTest do
  use ExUnit.Case, async: true

  alias CloudfrontSigner.Distribution
  alias CloudfrontSigner.DistributionRegistry

  describe "get_distribution/2" do
    test "returns cached distribution" do
      first_distribution = DistributionRegistry.get_distribution(:cloudfront_signer, __MODULE__)
      second_distribution = DistributionRegistry.get_distribution(:cloudfront_signer, __MODULE__)

      assert %Distribution{} = first_distribution
      assert first_distribution == second_distribution
      assert first_distribution.domain =~ "cloudfront.net"
    end

    test "creates and caches new distribution from config" do
      distribution = DistributionRegistry.get_distribution(:cloudfront_signer, __MODULE__)

      assert %Distribution{} = distribution
      assert distribution.domain =~ "cloudfront.net"
      assert ^distribution = DistributionRegistry.get_distribution(:cloudfront_signer, __MODULE__)
    end
  end
end
