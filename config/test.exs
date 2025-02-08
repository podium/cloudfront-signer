import Config

config :cloudfront_signer, CloudfrontSigner.DistributionRegistryTest,
  domain: "https://test.cloudfront.net",
  private_key: System.get_env("TESTING_PRIVATE_KEY"),
  key_pair_id: "a_key_pair"

config :cloudfront_signer, CloudfrontSignerTest,
  domain: "https://test.cloudfront.net",
  private_key:
    System.get_env("TESTING_PRIVATE_KEY") ||
      raise("""
      environment variable TESTING_PRIVATE_KEY is missing.
      You can use the test/support/test_private_key.pem file for your tests.
      See the .env.sample file for more information.
      You can also generate one by calling: openssl genpkey -algorithm RSA
      """),
  key_pair_id: "a_key_pair"

config :cloudfront_signer,
  domain: "https://test.cloudfront.net",
  private_key: System.get_env("TESTING_PRIVATE_KEY"),
  key_pair_id: "a_key_pair"
