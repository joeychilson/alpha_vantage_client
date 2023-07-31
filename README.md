# AlphaVantage

An Elixir-based HTTP Client for Alpha Vantage API

## Installation

`AlphaVantage` is available on Hex. Add it to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:alpha_vantage_client, "~> 0.2.0"}
  ]
end
```

## Configuration

Add your API key to your config.exs file:

```elixir
config :alpha_vantage_client, :api_key, ""
```

You can set rate limit for API calls if you have a premium account:

```elixir
config :alpha_vantage_client, :interval, 1_000
config :alpha_vantage_client, :max, 5
```
