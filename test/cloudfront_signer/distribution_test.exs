defmodule CloudfrontSigner.DistributionTest do
  use ExUnit.Case, async: true

  alias CloudfrontSigner.Distribution

  @test_private_key_path "test/support/test_private_key.pem"

  describe "from_config/2" do
    test "creates distribution from config" do
      distribution = Distribution.from_config(:cloudfront_signer, CloudfrontSignerTest)

      assert %Distribution{} = distribution
      assert distribution.domain =~ "cloudfront.net"

      assert match?(
               {:RSAPrivateKey, :"two-prime", _modulus, _public_exponent, _private_exponent,
                _prime1, _prime2, _exponent1, _exponent2, _coefficient, _other_prime_infos},
               distribution.private_key
             )

      assert is_binary(distribution.key_pair_id)
    end

    test "handles system env vars in config" do
      System.put_env("TEST_DOMAIN", "test.cloudfront.net")

      Application.put_env(:cloudfront_signer, :test_env_config,
        domain: {:system, "TEST_DOMAIN"},
        private_key: System.get_env("TESTING_PRIVATE_KEY"),
        key_pair_id: "test-key-pair"
      )

      distribution = Distribution.from_config(:cloudfront_signer, :test_env_config)
      assert distribution.domain == "test.cloudfront.net"
    end

    test "handles file paths in config" do
      Application.put_env(:cloudfront_signer, :test_file_config,
        domain: "test.cloudfront.net",
        private_key: {:file, @test_private_key_path},
        key_pair_id: "test-key-pair"
      )

      distribution = Distribution.from_config(:cloudfront_signer, :test_file_config)

      assert match?(
               {:RSAPrivateKey, :"two-prime", _modulus, _public_exponent, _private_exponent,
                _prime1, _prime2, _exponent1, _exponent2, _coefficient, _other_prime_infos},
               distribution.private_key
             )
    end

    test "ignores unknown config keys" do
      Application.put_env(:cloudfront_signer, :test_unknown_config,
        domain: "test.cloudfront.net",
        private_key: System.get_env("TESTING_PRIVATE_KEY"),
        key_pair_id: "test-key-pair",
        unknown_key: "some value"
      )

      distribution = Distribution.from_config(:cloudfront_signer, :test_unknown_config)
      assert distribution.domain == "test.cloudfront.net"
    end

    test "raises on invalid PEM" do
      Application.put_env(:cloudfront_signer, :test_invalid_pem,
        domain: "test.cloudfront.net",
        private_key: "NOT A VALID PEM",
        key_pair_id: "test-key-pair"
      )

      assert_raise ArgumentError, "Invalid PEM for cloudfront private key", fn ->
        Distribution.from_config(:cloudfront_signer, :test_invalid_pem)
      end
    end
  end
end
