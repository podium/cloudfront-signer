# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [Unreleased]

## 1.0.0 - 2025-02-10

### ⚠️ Breaking Changes

- Remove Application module - users must now add `CloudfrontSigner.DistributionRegistry` to their own supervision tree

#### Example

```elixir
# In your application.ex
def start(_type, _args) do
  children = [
    # ... other children ...
    CloudfrontSigner.DistributionRegistry
  ]
  
  opts = [strategy: :one_for_one, name: YourApp.Supervisor]
  Supervisor.start_link(children, opts)
end
```

### 🚀 Features

- Enforce key order in AWS Policy using Jason.OrderedObject
- Add support for Elixir version 1.15
- Add Styler for consistent code formatting

### 🚜 Refactor

- Remove unused Poison dependency
- Fix test expectations in CloudfrontSignerTest
- Remove test for non-existent module
- Replace Timex with DateTime

### 📚 Documentation

- Update README with guidance for installing via hex
- Add directions for adding registry to application supervision tree
- Improve function docs and typespecs
- Improve test documentation and formatting

## 0.2.0 - 2025-01-28

### 🚀 Features

- Swap Poison for Jason

### 🐛 Bug Fixes

- @spec should match function guards
- Optional argument as last arg

### 🚜 Refactor

- Refactor to custom policy

### 📚 Documentation

- Add docs
- Syntax fix
