defmodule PlugoidDemoWeb.PageController do
  @moduledoc false

  use PlugoidDemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
