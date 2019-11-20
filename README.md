# AskimetEx

[AskimetEx](https://hex.pm/packages/askimet_ex) is a package for use TypePad's AntiSpam services or Askimet endpoints in elixir projects.

## Installation

The package can be installed by adding `askimet_ex` 
to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:askimet_ex, "~> 0.1.1"}
  ]
end
```

Read the [Documentation](https://hexdocs.pm/askimet_ex)

## Usage

Use the module with parameters:

- Askimet API Key
- Blog URL
- User IP Address
- Comment or message

```elixir
AskimetEx.check_spam(api_key, blog_url, user_ip, comment)
```

## Collaborate

If you want to collaborate, please make a pull request.
