defmodule CloudfrontSigner.Application do
  @moduledoc """
  This module is the entry point for the CloudfrontSigner application.
  """

  use Application

  def start(_type, _args) do
    children = [
      CloudfrontSigner.DistributionRegistry
    ]

    opts = [strategy: :one_for_one, name: CloudfrontSigner.Application.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
