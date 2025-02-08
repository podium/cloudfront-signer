defmodule CloudfrontSignerTest do
  use ExUnit.Case, async: true

  doctest CloudfrontSigner

  describe "#sign/3" do
    test "it will return something" do
      distribution =
        CloudfrontSigner.Distribution.from_config(:cloudfront_signer, CloudfrontSignerTest)

      signed_url = CloudfrontSigner.sign(distribution, "/bucket/key", 60, arg: "val")

      assert signed_url =~ "Policy="
      assert signed_url =~ "Signature="
      assert signed_url =~ "Key-Pair-Id="
      assert signed_url =~ "/bucket/key?arg=val"
    end

    test "handles query params as string" do
      distribution =
        CloudfrontSigner.Distribution.from_config(:cloudfront_signer, CloudfrontSignerTest)

      signed_url = CloudfrontSigner.sign(distribution, "/bucket/key", 60, "arg=val")

      assert signed_url =~ "/bucket/key?arg=val"
    end

    test "handles empty query params" do
      distribution =
        CloudfrontSigner.Distribution.from_config(:cloudfront_signer, CloudfrontSignerTest)

      signed_url = CloudfrontSigner.sign(distribution, "/bucket/key", 60)

      assert signed_url =~ "/bucket/key?"
      refute signed_url =~ "/bucket/key??"
    end

    test "handles empty string query params" do
      distribution =
        CloudfrontSigner.Distribution.from_config(:cloudfront_signer, CloudfrontSignerTest)

      signed_url = CloudfrontSigner.sign(distribution, "/bucket/key", 60, "")

      assert signed_url =~ "/bucket/key?"
      refute signed_url =~ "/bucket/key??"
    end
  end
end
