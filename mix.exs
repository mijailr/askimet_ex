defmodule AskimetEx.MixProject do
  use Mix.Project

  @description """
    AskimetEx is a lib for use TypePad's AntiSpam services or Askimet endpoints in elixir projects.
  """

  def project do
    [
      app: :askimet_ex,
      name: "AskimetEx",
      description: @description,
      source_url: "https://github.com/mijailr/askimet_ex",
      version: "0.1.0",
      elixir: "~> 1.7",
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      application: [:hackney]
    ]
  end

  defp deps do
    [
      {:hackney, "~> 1.15 and >= 1.15.2"},

      # Test and dev dependencies
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.18.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Mijail Rondon Viloria"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/mijailr/askimet_ex"
      }
    ]
  end
end
