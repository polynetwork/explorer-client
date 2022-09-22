defmodule Explorer.ExchangeRates.Source.CoinMarketCapTest do
  use ExUnit.Case

  alias Explorer.ExchangeRates.Token
  alias Explorer.ExchangeRates.Source.CoinMarketCap
  alias Plug.Conn

  describe "format_data/1" do
    setup do
      bypass = Bypass.open()
      Application.put_env(:explorer, CoinMarketCap, base_url: "http://localhost:#{bypass.port}")

      {:ok, bypass: bypass}
    end

    test "returns valid tokens with valid data", %{bypass: bypass} do

      json_data =
        "#{File.cwd!()}/test/support/fixture/exchange_rates/coin_market_cap.json"
        |> File.read!()
        |> Jason.decode!()

      expected = [
       %Token{
          available_supply: Decimal.new("60000000"),
          btc_value: nil,
          id: 3897,
          last_updated: ~U[2022-09-19 09:28:00.000Z],
          market_cap_usd: Decimal.new("873906619.7145504"),
          name: "OKB",
          symbol: "OKB",
          total_supply: Decimal.new("300000000"),
          usd_value: Decimal.new("14.56511032857584"),
          volume_24h_usd: Decimal.new("25717460.6644868")
        },
        %Token{
          available_supply: Decimal.new("0"),
          btc_value: nil,
          id: 8267,
          last_updated: ~U[2022-09-19 09:28:00.000Z],
          market_cap_usd: Decimal.new("0"),
          name: "OKC Token",
          symbol: "OKT",
          total_supply: Decimal.new("11547688"),
          usd_value: Decimal.new("14.07099129539455"),
          volume_24h_usd: Decimal.new("2366350.60428721")
        }
      ]
#
      assert expected == CoinMarketCap.format_data(json_data)
    end

    test "returns nothing when given bad data" do
      bad_data = """
        [{"id": "poa-network"}]
      """

      assert [] = CoinMarketCap.format_data(bad_data)
    end
  end

  describe "coin_id/0" do
    setup do
      on_exit(fn ->
        Application.put_env(:explorer, :coin, "ZION")
      end)
    end
    test "generate source url" do

      expected = "https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/latest?id=3897,8267&CMC_PRO_API_KEY="
      assert expected == CoinMarketCap.source_url([3897,8267])
    end
  end
end
