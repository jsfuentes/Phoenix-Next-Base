defmodule PhoenixBaseWeb.Helpers.DailyHelper do
  require Logger

  # Helpers, crash if api request fails to daily
  def create_room(rawProperties \\ %{}) do
    nowUTC = DateTime.utc_now() |> DateTime.to_unix()

    # 5 * 60 is 5 minutes I think
    properties =
      rawProperties
      # |> Map.put_new(:exp, nowUTC + 5 * 60)
      |> Map.put_new(:exp, nowUTC + 6 * 60 * 60)
      |> Map.put_new(:start_audio_off, false)
      |> Map.put_new(:start_video_off, false)

    rawPayload = %{
      privacy: "public",
      properties: properties
    }

    payload = Jason.encode!(rawPayload)
    url = "https://api.daily.co/v1/rooms"

    headers = [
      Accept: "Application/json; Charset=utf-8",
      "Content-Type": "Application/json; charset=utf-8",
      Authorization: "Bearer #{Application.fetch_env!(:phoenix_base, :daily_api)}"
    ]

    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.post!(url, payload, headers)
    Logger.info("Daily create room")
    Jason.decode!(body)
  end

  def delete_room(%{"name" => name}) do
    url = "https://api.daily.co/v1/rooms/#{name}"

    headers = [
      Accept: "Application/json; Charset=utf-8",
      "Content-Type": "Application/json; charset=utf-8",
      Authorization: "Bearer #{Application.fetch_env!(:phoenix_base, :daily_api)}"
    ]

    case HTTPoison.delete(url, headers) do
      #   body: "{\"deleted\":true,\"name\":\"MshIFPeySTTqSHs1t1gW\"}",
      {:ok, %HTTPoison.Response{status_code: 200, body: _body}} ->
        Logger.info("Deleted room #{name}")
        nil

      #   body: "{\"error\":\"not-found\",\"info\":\"room 'fZpOVdXNLX5wSXMj24VC' not found\"}",
      {:ok, %HTTPoison.Response{status_code: 404, body: _body}} ->
        Logger.info("Already deleted room #{name}")
        nil

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Problem deleting room because #{reason}")
        nil
    end
  end
end
