defmodule Explorer.Counters.AddressTokenUsdSum do
  @moduledoc """
  Caches Address tokens USD value.
  """
  use GenServer

  alias Explorer.Chain
#  alias Explorer.Counters.Helper

  @cache_name :address_tokens_usd_value
#  @last_update_key "last_update"

  config = Application.get_env(:explorer, Explorer.Counters.AddressTokenUsdSum)
  @enable_consolidation Keyword.get(config, :enable_consolidation)

  @spec start_link(term()) :: GenServer.on_start()
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(_args) do
#    create_cache_table()

    {:ok, %{consolidate?: enable_consolidation?()}, {:continue, :ok}}
  end

  @impl true
  def handle_continue(:ok, %{consolidate?: true} = state) do
    {:noreply, state}
  end

  @impl true
  def handle_continue(:ok, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info(:consolidate, state) do
    {:noreply, state}
  end

  def fetch(_address_hash_string, token_balances) do
      Chain.address_tokens_usd_sum(token_balances)
  end

  def cache_name, do: @cache_name

#  defp cache_expired?(address_hash_string) do
#    cache_period = address_tokens_usd_sum_cache_period()
#    updated_at = fetch_from_cache("hash_#{address_hash_string}_#{@last_update_key}")
#
#    cond do
#      is_nil(updated_at) -> true
#      Helper.current_time() - updated_at > cache_period -> true
#      true -> false
#    end
#  end

#  defp update_cache(address_hash_string, token_balances) do
#    put_into_cache("hash_#{address_hash_string}_#{@last_update_key}", Helper.current_time())
#    new_data = Chain.address_tokens_usd_sum(token_balances)
#    put_into_cache("hash_#{address_hash_string}", new_data)
#  end
#
#  defp fetch_from_cache(key) do
#    Helper.fetch_from_cache(key, @cache_name)
#  end
#
#  defp put_into_cache(key, value) do
#    :ets.insert(@cache_name, {key, value})
#  end
#
#  defp create_cache_table do
#    Helper.create_cache_table(@cache_name)
#  end

  defp enable_consolidation?, do: @enable_consolidation

#  defp address_tokens_usd_sum_cache_period do
#    Helper.cache_period("CACHE_ADDRESS_TOKENS_USD_SUM_PERIOD", 1)
#  end
end
