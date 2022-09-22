defmodule Indexer.Supervisor do
  @moduledoc """
  Supervisor of all indexer worker supervision trees
  """

  use Supervisor

  alias Indexer.Fetcher.{
    CoinBalanceOnDemand
    }

  def child_spec([]) do
    child_spec([[]])
  end

  def child_spec([init_arguments]) do
    child_spec([init_arguments, []])
  end

  def child_spec([_init_arguments, _gen_server_options] = start_link_arguments) do
    default = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, start_link_arguments},
      type: :supervisor
    }

    Supervisor.child_spec(default, [])
  end

  def start_link(arguments, gen_server_options \\ []) do
    Supervisor.start_link(__MODULE__, arguments, Keyword.put_new(gen_server_options, :name, __MODULE__))
  end

  @impl Supervisor
  def init(%{memory_monitor: _memory_monitor}) do
    json_rpc_named_arguments = Application.fetch_env!(:indexer, :json_rpc_named_arguments)

    coin_balance_fetcher = [
      {CoinBalanceOnDemand.Supervisor, [json_rpc_named_arguments]}
    ]

    Supervisor.init(
      coin_balance_fetcher,
      strategy: :one_for_one
    )
  end
end
