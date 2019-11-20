defmodule AskimetExTest do
  use ExUnit.Case
  import FakeServer

  test "invalid key" do
    {:error, reason} =
      AskimetEx.check_spam(
        "invavalidaskimetapikey",
        "https://example.com",
        "192.138.1.1",
        "viagra-test-123"
      )

    assert reason == "Invalid key"
  end
end
