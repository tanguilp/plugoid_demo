defmodule PlugoidDemoWeb.LogoutController do
  @moduledoc false

  use PlugoidDemoWeb, :controller

  def index(conn, _params) do
    conn
    |> Plugoid.logout()
    |> redirect(to: "/")
  end
end
