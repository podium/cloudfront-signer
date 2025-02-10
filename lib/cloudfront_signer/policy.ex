defmodule CloudfrontSigner.Policy do
  @moduledoc """
  Defines a cloudfront signature policy, and a string coercion method for it
  """
  defstruct [:resource, :expiry]

  @type t :: %__MODULE__{
          resource: String.t(),
          expiry: integer()
        }

  @typedoc """
  Type definition for an RSA private key in ASN.1 format.
  The tuple elements represent:
  - :RSAPrivateKey - The key type identifier
  - :"two-prime" - The RSA version identifier
  - modulus - The RSA modulus n
  - publicExponent - The public exponent e
  - privateExponent - The private exponent d
  - prime1 - The first prime factor p of n
  - prime2 - The second prime factor q of n
  - exponent1 - d mod (p-1)
  - exponent2 - d mod (q-1)
  - coefficient - The CRT coefficient q^(-1) mod p
  - otherPrimeInfos - Optional additional prime info (usually :asn1_NOVALUE)
  """
  @type rsa_private_key :: {
          :RSAPrivateKey,
          :"two-prime",
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer(),
          :asn1_NOVALUE | [non_neg_integer()]
        }

  @doc """
  Generates a CloudFront URL signature and policy for a given resource.

  Takes a policy struct containing the resource URL and expiry time, along with an RSA private key,
  and returns a tuple containing the URL-safe base64 encoded signature and the base64 encoded policy.

  The signature is generated using SHA-1 with RSA encryption (SHA1withRSA) and is URL-safe encoded.
  The policy is a JSON document that specifies what resource is being accessed and when the signature expires.

  ## Parameters

    * `policy` - A `Policy` struct containing:
      * `resource` - The URL of the CloudFront resource to be accessed
      * `expiry` - Unix timestamp when the signature should expire
    * `private_key` - An RSA private key in ASN.1 format (decoded from PEM)

  ## Returns

    * `{signature, encoded_policy}` where:
      * `signature` - URL-safe base64 encoded signature
      * `encoded_policy` - Base64 encoded JSON policy document

  """
  @spec generate_signature_and_policy(t(), rsa_private_key()) :: {String.t(), String.t()}
  def generate_signature_and_policy(%__MODULE__{} = policy, private_key) do
    policy_as_str =
      policy.resource
      |> aws_policy(policy.expiry)
      |> Jason.encode!()

    signature =
      policy_as_str
      |> String.replace(~r/\s+/, "")
      |> :public_key.sign(:sha, private_key)
      |> Base.encode64()
      |> String.replace(["+", "=", "/"], fn
        "+" -> "-"
        "=" -> "_"
        "/" -> "~"
      end)

    {signature, Base.encode64(policy_as_str)}
  end

  defp aws_policy(resource, expiry) do
    Jason.OrderedObject.new([
      {"Statement",
       [
         Jason.OrderedObject.new([
           {"Resource", resource},
           {"Condition",
            Jason.OrderedObject.new([
              {"DateLessThan",
               Jason.OrderedObject.new([
                 {"AWS:EpochTime", expiry}
               ])}
            ])}
         ])
       ]}
    ])
  end
end
