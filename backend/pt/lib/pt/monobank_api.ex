defmodule Pt.MonobankApi do
  @client_api_url "https://api.monobank.ua/personal/client-info"

  def handle_response(response) do
    case response.status_code do
      200 -> {:ok, Jason.decode!(response.body)}
      _ -> {:error, Jason.decode!(response.body)["errorDescription"]}
    end
  end

  def fetch_client(token) do
    HTTPoison.get!(@client_api_url, [{"X-Token", token}]) |> handle_response()
  end

  def resolve_client_account_statement_api_url(accountId, from, to) do
    "https://api.monobank.ua/personal/statement/#{accountId}/#{from}/#{to}"
  end

  def fetch_client_account_statement(%{accountId: accountId, from: from, to: to}, token) do
    api_url = resolve_client_account_statement_api_url(accountId, from, to)

    with {:ok, entries} <- HTTPoison.get!(api_url, [{"X-Token", token}]) |> handle_response() do
      entries
    end
  end

  def fetch_client_account_statement_for_last_week(accountId, token) do
    from = Timex.to_unix(Timex.shift(Timex.now(), days: -7))
    to = Timex.to_unix(Timex.now())

    fetch_client_account_statement(%{accountId: accountId, from: from, to: to}, token)
  end

  def fetch_client_account_statement_for_last_month(accountId, token) do
    from = Timex.to_unix(Timex.shift(Timex.now(), days: -31))
    to = Timex.to_unix(Timex.now())

    fetch_client_account_statement(%{accountId: accountId, from: from, to: to}, token)
  end
end
