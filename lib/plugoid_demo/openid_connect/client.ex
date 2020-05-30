defmodule PlugoidDemo.OpenIDConnect.Client do
  @moduledoc false

  @behaviour OIDC.ClientConfig

  @impl true
  def get("client1") do
    %{
      "client_id" => "client1",
      "client_secret" => "clientpassword1"
    }
  end

  def get("client2") do
    %{
      "client_id" => "client2",
      "client_secret" => "clientpassword2"
    }
  end

  def get(_) do
    nil
  end
end
