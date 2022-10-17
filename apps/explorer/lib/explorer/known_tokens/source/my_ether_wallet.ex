defmodule Explorer.KnownTokens.Source.MyEtherWallet do
  @moduledoc """
  Adapter for fetching known tokens from MyEtherWallet's GitHub
  """

  alias Explorer.KnownTokens.Source

  @behaviour Source

  @impl Source
  def source_url do
    "https://raw.githubusercontent.com/NoneShen/blockscout/client/tokens.json"
  end

  @impl Source
  def headers do
    []
  end
end
