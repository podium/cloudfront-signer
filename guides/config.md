# Configuration

## Env vars

| Name | Description | Default value |
|------|-------------|---------------|
| `PRIVATE_KEY` | The private key for signing CloudFront URLs. This should be a PEM-encoded RSA private key. | None |
| `KEY_PAIR_ID` | The CloudFront key pair ID associated with the private key. | None |
| `TESTING_PRIVATE_KEY` | The private key used for testing. This should be a PEM-encoded RSA private key. Only needed for running tests. | See `.github/workflows/ci.yml` |