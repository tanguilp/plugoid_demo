defmodule PlugoidDemo.OpenIDConnect do
  @moduledoc false

  alias PlugoidDemo.OpenIDConnect.Client
  alias OIDC.Auth.OPResponseSuccess

  def token_callback(op_response, issuer, client_id, opts) do
    client_config = Client.get(client_id)

    maybe_register_access_token(op_response, issuer, client_config, opts)
    maybe_register_refresh_token(op_response, issuer, client_config, opts)
    OAuth2TokenManager.Claims.register_id_token(issuer, op_response.id_token)
  end

  defp maybe_register_access_token(%OPResponseSuccess{access_token: nil}, _, _, _) do
    :ok
  end

  defp maybe_register_access_token(op_response, issuer, client_conf, opts) do
    token_metadata =
      if op_response.access_token_expires_in do
        %{"exp" => System.system_time(:second) + op_response.access_token_expires_in}
      else
        %{}
      end
      |> Map.put("scope", op_response.granted_scopes)

    OAuth2TokenManager.AccessToken.register(
      op_response.access_token,
      op_response.access_token_type,
      token_metadata,
      issuer,
      client_conf,
      opts
    )
  end

  defp maybe_register_refresh_token(%OPResponseSuccess{refresh_token: nil}, _, _, _) do
    :ok
  end

  defp maybe_register_refresh_token(op_response, issuer, client_conf, opts) do
    OAuth2TokenManager.RefreshToken.register(
      op_response.refresh_token,
      %{"scope" => op_response.granted_scopes},
      issuer,
      client_conf,
      opts
    )
  end
end
