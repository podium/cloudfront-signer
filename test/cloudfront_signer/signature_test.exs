defmodule CloudfrontSigner.SignatureTest do
  use ExUnit.Case, async: true

  @distribution CloudfrontSigner.Distribution.from_config(
                  :cloudfront_signer,
                  CloudfrontSignerTest
                )

  @policy %CloudfrontSigner.Policy{
    resource: "https://cloudfront.domain.com/some/path",
    expiry: 1_527_884_313
  }

  @correct_signature CloudfrontSigner.Signature.signature(@policy, @distribution.private_key)

  describe "#signature/2" do
    test "It will compute the correct signature for a policy" do
      assert CloudfrontSigner.Signature.signature(@policy, @distribution.private_key) ==
               @correct_signature
    end

    test "It will compute a different signature for a different policy" do
      policy = %CloudfrontSigner.Policy{
        resource: "https://cloudfront.domain.com/some/path",
        expiry: 60
      }

      assert CloudfrontSigner.Signature.signature(policy, @distribution.private_key) !=
               @correct_signature
    end
  end
end

