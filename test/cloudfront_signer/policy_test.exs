defmodule CloudfrontSigner.PolicyTest do
  use ExUnit.Case, async: true
  alias CloudfrontSigner.Policy

  @test_private_key_path "test/support/test_private_key.pem"

  describe "generate_signature_and_policy/2" do
    test "generates policy with fields in correct order" do
      policy = %Policy{resource: "/test/path", expiry: 1_234_567_890}

      private_key =
        @test_private_key_path
        |> File.read!()
        |> :public_key.pem_decode()
        |> hd()
        |> :public_key.pem_entry_decode()

      {_signature, policy_base64} = Policy.generate_signature_and_policy(policy, private_key)

      policy_json = Base.decode64!(policy_base64)
      assert policy_json =~ ~r/Resource.*Condition/s
    end
  end
end
