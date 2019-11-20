defmodule AskimetEx do
  @moduledoc """
  This module use the askimet API to check if a comment is
  considered as spam.
  """

  defstruct blog: nil,
            content: nil,
            host: "rest.akismet.com",
            key: nil,
            user_ip: nil

  @type t :: %__MODULE__{
          blog: String.t(),
          content: String.t(),
          host: String.t(),
          key: String.t(),
          user_ip: String.t()
        }

  @doc """
  This method check if a commentary is considered as spam

   - If the API key is valid and is a good commentary, return {:ok, false}
  - If the API key is valid and is spam return {:ok, true}
  - If the API key is not valid, return {:error, "Invalid Key"}
  - Else return {:error, "Can't handle the request"}

  ## Example
      iex> AskimetEx.check_spam("validaskimetapikey", "https://mijailr.com", "192.138.1.1", "This is a good commentary for askimet")
      {:ok, false}
      iex> AskimetEx.check_spam("validaskimetapikey", "https://mijailr.com", "192.138.1.1", "viagra-test-123")
      {:ok, true}
      iex> AskimetEx.check_spam("invalidaskimetapikey", "https://mijailr.com", "192.138.1.1", "other message to check")
      {:error, "Invalid key"}
  """
  @spec check_spam(binary, binary, binary, binary) :: {:ok, boolean} | {:error, String.t()}
  def check_spam(key, blog, user_ip, content, host \\ "rest.akismet.com") do
    request = %AskimetEx{
      blog: blog,
      content: content,
      host: host,
      key: key,
      user_ip: user_ip
    }

    case valid_key?(request) do
      true ->
        check_spam(request)

      _ ->
        {:error, "Invalid key"}
    end
  end

  defp check_spam(%AskimetEx{} = request) do
    process_request("comment-check", request)
    |> case do
      {:ok, body} ->
        {:ok, is_spam?(body)}

      {_, body} ->
        {:error, body}
    end
  end

  defp valid_key?(%AskimetEx{} = request) do
    process_request("verify", request)
    |> case do
      {:ok, body} ->
        body == "valid"

      _ ->
        false
    end
  end

  defp process_request(action, %AskimetEx{} = request) do
    headers = request_headers()
    payload = query_payload(action, request)
    url = url_for(action, request.key, request.host)

    case :hackney.post(url, headers, payload) do
      {:ok, _, _, ref} ->
        :hackney.body(ref)

      _ ->
        {:error, "Can't handle the request"}
    end
  end

  defp url_for("verify", _, host), do: "https://#{host}/1.1/verify-key"
  defp url_for(action, key, host), do: "https://#{key}.#{host}/1.1/#{action}"

  defp query_payload("verify", request) do
    %{
      key: request.key,
      blog: request.blog
    }
    |> URI.encode_query()
  end

  defp query_payload("comment-check", request) do
    %{
      user_ip: request.user_ip,
      blog: request.blog,
      comment_content: request.content
    }
    |> URI.encode_query()
  end

  defp request_headers do
    [
      Accept: "*/*",
      "User-Agent": "AskimetEx/#{version()}",
      "Content-Type": "application/x-www-form-urlencoded"
    ]
  end

  defp is_spam?(body), do: body == "true"

  defp version do
    Application.spec(:askimet_ex, :vsn)
  end
end
