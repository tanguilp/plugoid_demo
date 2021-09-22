# PlugoidDemo

Phoenix demo application that uses the [`Plugoid`](https://github.com/tanguilp/plugoid) library
to authenticate users.

![Plugoid Demo app main page](https://raw.githubusercontent.com/tanguilp/plugoid_demo/master/media/main_page.png)

## Compatibility

OTP 22+

## Launching the demo application

In a shell, launch the following commands:

```bash
git clone https://github.com/tanguilp/plugoid_demo.git

cd plugoid_demo/

mix deps.get

cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development && cd ..

iex -S mix phx.server
```

and open [localhost:4000](http://localhost:4000).

## OpenID Provider

The demo uses
[https://repentant-brief-fishingcat.gigalixirapp.com/](https://repentant-brief-fishingcat.gigalixirapp.com/)
as an OpenID Provider. It runs the [Asteroid](https://github.com/tanguilp/asteroid) OAuth2 /
OpenID Connect server.

The first factor is always the `123456` password. The second factor is an OTP code sent by
email. In such a case, you have to use an email address as a login (it is stored but not used
whatsoever). The OTP email will possibily be marked as a spam, check in your spam folder if
you can't see it.

If the server is down (e.g. visiting
[https://repentant-brief-fishingcat.gigalixirapp.com/.well-known/openid-configuration](https://repentant-brief-fishingcat.gigalixirapp.com/.well-known/openid-configuration))
results in an error, open an issue on the Asteroid tracker.

To modify the OpenID Connect server, change the issuer in `lib/plugoid_demo_web/router.ex`.

## OAuth2 tokens

The first 2 links (`/private`) use the authorization code flow, and therefore some tokens are
returned.

Using the issuer and subject shown on the demo page, one can use
[`OAuth2TokenManager`](https://github.com/tanguilp/oauth2_token_manager) library included in the
demo application to retrieve OAuth2 tokens, ID tokens and claims.

For instance:

```elixir
iex> cc = PlugoidDemo.OpenIDConnect.Client.get("client1")
%{"client_id" => "client1", "client_secret" => "clientpassword1"}

iex> OAuth2TokenManager.AccessToken.get("https://repentant-brief-fishingcat.gigalixirapp.com", "cThpjg2-HzfS_7fvNkCYeEUBkCUpmKFSjzb6iebl5TU", cc, nil)
{:ok, {"mcR_hHPaCTRdb09Mtm4FsIlPyYE", "bearer"}}

iex> OAuth2TokenManager.AccessToken.get("https://repentant-brief-fishingcat.gigalixirapp.com", "cThpjg2-HzfS_7fvNkCYeEUBkCUpmKFSjzb6iebl5TU", cc, ["read_account_information", "read_balance"])
{:ok, {"HjRo0pkxY4LFmCiKNfDT-OLvEwY", "bearer"}}

iex> OAuth2TokenManager.AccessToken.get("https://repentant-brief-fishingcat.gigalixirapp.com", "cThpjg2-HzfS_7fvNkCYeEUBkCUpmKFSjzb6iebl5TU", cc, ["read_account_information"])
{:ok, {"X6o9UDEJEpkp2kr8EA-68toX1Es", "bearer"}}

iex> OAuth2TokenManager.Claims.get_id_token("https://repentant-brief-fishingcat.gigalixirapp.com", "cThpjg2-HzfS_7fvNkCYeEUBkCUpmKFSjzb6iebl5TU")
{:ok,
 "eyJhbGciOiJSUzI1NiJ9.eyJhY3IiOiIxLWZhY3RvciIsImFtciI6WyJwd2QiXSwiYXVkIjoiY2xpZW50MSIsImF1dGhfdGltZSI6MTU5MDc4MjQwMSwiZXhwIjoxNTkwNzgyNDYyLCJpYXQiOjE1OTA3ODI0MDIsImlzcyI6Imh0dHBzOi8vcmVwZW50YW50LWJyaWVmLWZpc2hpbmdjYXQuZ2lnYWxpeGlyYXBwLmNvbSIsInN1YiI6ImNUaHBqZzItSHpmU183ZnZOa0NZZUVVQmtDVXBtS0ZTanpiNmllYmw1VFUifQ.LDUDgIntqkAGqpU8UdpQEqFmelCH6q0gJT_mUij-POamcMzoixP-Y1VqVhzPLKlPvontcejgHWA4pJg2FhwcpSWdc27bspil_cGQco0mf2Tzge0JUf88gR3JvqES1bLzRwF40oyQxox0dWh-dh0cf5zhf9vga_rRN3HexmsFwLbFJpudtZzsUdmXYYEjpmjH4Ja9zBjv5-g3g10UGjeFVtAwDv2urK9eyEn2aStUgcmf0yxiyHoyTAa9QPkJ6_3YBIT9s0saKlBV9gUqNp6_ogv6jvLDhMqCkw9xqVfMICeoSjSxc8Uawut6_f-aedLVSNQEKifR0KkUC3D2amPZog"}

iex> OAuth2TokenManager.Claims.get_claims("https://repentant-brief-fishingcat.gigalixirapp.com", "cThpjg2-HzfS_7fvNkCYeEUBkCUpmKFSjzb6iebl5TU", cc)
{:ok, %{"sub" => "cThpjg2-HzfS_7fvNkCYeEUBkCUpmKFSjzb6iebl5TU"}}
```

## JTI register

The [`JTIRegister.ETS`](https://hexdocs.pm/jti_register/JTIRegister.ETS.html) JTI register is
installed by default.

One can observe the registered JTI by opening the observer (`:observer.start` in the iex shell)
and opening the `Elixir.JTIRegister.ETS` table in the "Table Viewer" tab:

![JTI ETS table](https://raw.githubusercontent.com/tanguilp/plugoid_demo/master/media/jti_ets_table.png)
