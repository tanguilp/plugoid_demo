defmodule PlugoidDemoWeb.ComponentView do
  use PlugoidDemoWeb, :view

  def authenticated?(conn), do: Plugoid.authenticated?(conn)

  def issuer(conn), do: Plugoid.issuer(conn)

  def subject(conn), do: Plugoid.subject(conn)

  def auth_info(conn) do
    case issuer(conn) do
      nil ->
        nil

      issuer ->
        Plugoid.Session.AuthSession.info(conn, issuer)
    end
  end

  def acr(conn) do
    case auth_info(conn) do
      %_{} = auth_info ->
        auth_info.acr

      nil ->
        nil
    end
  end

  def auth_time(conn) do
    case auth_info(conn) do
      %_{} = auth_info ->
        auth_info.auth_time_monotonic

      nil ->
        nil
    end
  end

  def method(conn), do: conn.method

  def query_params(conn),
    do: conn.query_params |> inspect(pretty: true) |> Makeup.highlight() |> raw()

  def body(conn), do: conn.body_params |> inspect(pretty: true) |> Makeup.highlight() |> raw()

  def redirected_from_op?(conn), do: Plugoid.redirected_from_OP?(conn)
end
