defmodule PlugoidDemoWeb.Router do
  @moduledoc false

  use PlugoidDemoWeb, :router
  use Plugoid.RedirectURI,
    jti_register: JTIRegister.ETS,
    tesla_middlewares: [Tesla.Middleware.Logger],
    token_callback: &PlugoidDemo.OpenIDConnect.token_callback/5

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    plug Plug.Parsers, parsers: [:urlencoded]
  end

  pipeline :one_factor do
    plug Plugoid,
      issuer: "https://repentant-brief-fishingcat.gigalixirapp.com",
      client_id: "client1",
      client_config: PlugoidDemo.OpenIDConnect.Client,
      tesla_middlewares: [Tesla.Middleware.Logger],
      preserve_initial_request: true,
      response_type: "code",
      scope: ["interbank_transfer", "read_account_information", "read_balance"]
  end

  pipeline :one_factor_optional do
    plug Plugoid,
      issuer: "https://repentant-brief-fishingcat.gigalixirapp.com",
      client_id: "client1",
      client_config: PlugoidDemo.OpenIDConnect.Client,
      on_unauthenticated: :pass,
      tesla_middlewares: [Tesla.Middleware.Logger]
  end

  pipeline :two_factor do
    plug Plugoid,
      issuer: "https://repentant-brief-fishingcat.gigalixirapp.com",
      client_id: "client1",
      client_config: PlugoidDemo.OpenIDConnect.Client,
      acr_values: ["2-factor"],
      tesla_middlewares: [Tesla.Middleware.Logger]
  end

  pipeline :two_factor_mandatory do
    plug Plugoid,
      issuer: "https://repentant-brief-fishingcat.gigalixirapp.com",
      client_id: "client1",
      client_config: PlugoidDemo.OpenIDConnect.Client,
      claims: %{
        "id_token" => %{
          "acr" => %{
            "essential" => true,
            "value" => "2-factor"
          }
        }
      },
      tesla_middlewares: [Tesla.Middleware.Logger]
  end

  pipeline :two_factor_mandatory_fail do
    plug Plugoid,
      issuer: "https://repentant-brief-fishingcat.gigalixirapp.com",
      client_id: "client1",
      client_config: PlugoidDemo.OpenIDConnect.Client,
      claims: %{
        "id_token" => %{
          "acr" => %{
            "essential" => true,
            "value" => "2-factor"
          }
        }
      },
      on_unauthorized: :fail,
      tesla_middlewares: [Tesla.Middleware.Logger]
  end

  scope "/", PlugoidDemoWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/logout", LogoutController, :index
  end

  scope "/private", PlugoidDemoWeb do
    pipe_through :browser
    pipe_through :one_factor

    get "/", PageController, :index
    post "/", PageController, :index
  end

  scope "/public_private", PlugoidDemoWeb do
    pipe_through :browser
    pipe_through :one_factor_optional

    get "/", PageController, :index
  end

  scope "/2factor", PlugoidDemoWeb do
    pipe_through :browser
    pipe_through :two_factor

    get "/", PageController, :index
  end

  scope "/2factor_mandatory", PlugoidDemoWeb do
    pipe_through :browser
    pipe_through :two_factor_mandatory

    get "/", PageController, :index
  end

  scope "/2factor_mandatory_fail", PlugoidDemoWeb do
    pipe_through :browser
    pipe_through :two_factor_mandatory_fail

    get "/", PageController, :index
  end
end
