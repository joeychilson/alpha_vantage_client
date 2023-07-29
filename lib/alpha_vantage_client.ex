defmodule AlphaVantage do
  use Application

  def start(_type, _args) do
    interval = Application.get_env(:alpha_vantage_client, :interval, 12_000)
    max = Application.get_env(:alpha_vantage_client, :max, 5)

    children = [
      {SimpleRateLimiter, interval: interval, max: max}
    ]

    opts = [strategy: :one_for_one, name: AlphaVantage.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Fetches the daily time series for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the time series for.
  * `interval` - The interval to fetch the time series for.

  ## Optional

  * `adjusted` - If true, the adjusted time series is returned.
  * `extended_hours` - If true, the extended hours time series is returned.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.
  """
  def time_series_intraday(symbol, interval, params \\ []) do
    Keyword.new([
      {:function, "TIME_SERIES_INTRADAY"},
      {:symbol, symbol},
      {:interval, interval}
    ])
    |> Keyword.merge(params)
    |> get()
  end

  @doc """
  Fetches the daily time series for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the time series for.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.
  """
  def time_series_daily(symbol, outputsize \\ "compact") do
    Keyword.new([
      {:function, "TIME_SERIES_DAILY"},
      {:symbol, symbol},
      {:outputsize, outputsize}
    ])
    |> get()
  end

  @doc """
  Fetches the daily adjusted time series for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the time series for.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.
  """
  def time_series_daily_adjusted(symbol, outputsize \\ "compact") do
    Keyword.new([
      {:function, "TIME_SERIES_DAILY_ADJUSTED"},
      {:symbol, symbol},
      {:outputsize, outputsize}
    ])
    |> get()
  end

  @doc """
  Fetches the weekly time series for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the time series for.
  """
  def time_series_weekly(symbol) do
    Keyword.new([{:function, "TIME_SERIES_WEEKLY"}, {:symbol, symbol}]) |> get()
  end

  @doc """
  Fetches the weekly adjusted time series for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the time series for.
  """
  def time_series_weekly_adjusted(symbol) do
    Keyword.new([{:function, "TIME_SERIES_WEEKLY_ADJUSTED"}, {:symbol, symbol}]) |> get()
  end

  @doc """
  Fetches the monthly time series for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the time series for.
  """
  def time_series_monthly(symbol) do
    Keyword.new([{:function, "TIME_SERIES_MONTHLY"}, {:symbol, symbol}]) |> get()
  end

  @doc """
  Fetches the monthly adjusted time series for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the time series for.
  """
  def time_series_monthly_adjusted(symbol) do
    Keyword.new([{:function, "TIME_SERIES_MONTHLY_ADJUSTED"}, {:symbol, symbol}]) |> get()
  end

  @doc """
  Fetches the quote for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the quote for.
  """
  def quote(symbol) do
    Keyword.new([{:function, "GLOBAL_QUOTE"}, {:symbol, symbol}]) |> get()
  end

  @doc """
  Fetches the search results for a given keyword.

  ## Required

  * `keywords` - The keywords to search for.
  """
  def search(keywords) do
    Keyword.new([{:function, "SYMBOL_SEARCH"}, {:keywords, keywords}]) |> get()
  end

  @doc """
  Fetches the market status.
  """
  def market_status do
    Keyword.new([{:function, "MARKET_STATUS"}]) |> get()
  end

  @doc """
  Fetches the news sentiment

  ## Optional

  * `tickers` - A comma-separated list of stock tickers.
  * `topics` - A comma-separated list of topics.
  * `time_from` - A date in the format  YYYYMMDDTHHMM.
  * `time_to` - A date in the format  YYYYMMDDTHHMM.
  * `sort` - The sort order of the results. Possible values are LATEST, EARLIEST, RELEVANCE.
  * `limit` - The number of results to return. Possible values are 1-1000.
  """
  def news_sentiment(params \\ []) do
    Keyword.new([{:function, "NEWS_SENTIMENT"}]) |> Keyword.merge(params) |> get()
  end

  @doc """
  Fetches the top gainers, losers, and most actively traded US tickers.
  """
  def top_gainers_losers_and_active do
    Keyword.new([{:function, "TOP_GAINERS_LOSERS"}]) |> get()
  end

  @doc """
  Fetches the company overview for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the overview for.
  """
  def company_overview(symbol) do
    Keyword.new([{:function, "OVERVIEW"}, {:symbol, symbol}]) |> get()
  end

  @doc """
  Fetches the income statements for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the income statements for.
  """
  def income_statements(symbol) do
    Keyword.new([{:function, "INCOME_STATEMENT"}, {:symbol, symbol}]) |> get()
  end

  @doc """
  Fetches the balance sheets for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the balance sheets for.
  """
  def balance_sheets(symbol) do
    Keyword.new([{:function, "BALANCE_SHEET"}, {:symbol, symbol}]) |> get()
  end

  @doc """
  Fetches the cash flow statements for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the cash flow statements for.
  """
  def cash_flow_statements(symbol) do
    Keyword.new([{:function, "CASH_FLOW"}, {:symbol, symbol}]) |> get()
  end

  @doc """
  Fetches the earnings for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the earnings for.
  """
  def earnings(symbol) do
    Keyword.new([{:function, "EARNINGS"}, {:symbol, symbol}]) |> get()
  end

  @doc """
  Fetches the current exchange rate for a given currency pair.

  ## Required

  * `from_currency` - The currency to convert from.
  * `to_currency` - The currency to convert to.
  """
  def fx_exchange_rates(from_currency, to_currency) do
    Keyword.new([
      {:function, "CURRENCY_EXCHANGE_RATE"},
      {:from_currency, from_currency},
      {:to_currency, to_currency}
    ])
    |> get()
  end

  @doc """
  Fetches the intraday exchange rate for a given currency pair.

  ## Required

  * `from_symbol` - The currency to convert from.
  * `to_symbol` - The currency to convert to.
  * `interval` - The interval between two consecutive data points in the time series.

  ## Optional

  * `outputsize` - The size of the time series to return. Either `compact` or `full`.
  """
  def fx_intraday(from_symbol, to_symbol, interval, outputsize \\ "compact") do
    Keyword.new([
      {:function, "FX_INTRADAY"},
      {:from_symbol, from_symbol},
      {:to_symbol, to_symbol},
      {:interval, interval},
      {:outputsize, outputsize}
    ])
    |> get()
  end

  @doc """
  Fetches the daily exchange rate for a given currency pair.

  ## Required

  * `from_symbol` - The currency to convert from.
  * `to_symbol` - The currency to convert to.

  ## Optional

  * `outputsize` - The size of the time series to return. Either `compact` or `full`.
  """
  def fx_daily(from_symbol, to_symbol, outputsize \\ "compact") do
    Keyword.new([
      {:function, "FX_DAILY"},
      {:from_symbol, from_symbol},
      {:to_symbol, to_symbol},
      {:outputsize, outputsize}
    ])
    |> get()
  end

  @doc """
  Fetches the weekly exchange rate for a given currency pair.

  ## Required

  * `from_symbol` - The currency to convert from.
  * `to_symbol` - The currency to convert to.

  ## Optional

  * `outputsize` - The size of the time series to return. Either `compact` or `full`.
  """
  def fx_weekly(from_symbol, to_symbol, outputsize \\ "compact") do
    Keyword.new([
      {:function, "FX_WEEKLY"},
      {:from_symbol, from_symbol},
      {:to_symbol, to_symbol},
      {:outputsize, outputsize}
    ])
    |> get()
  end

  @doc """
  Fetches the monthly exchange rate for a given currency pair.

  ## Required

  * `from_symbol` - The currency to convert from.
  * `to_symbol` - The currency to convert to.

  ## Optional

  * `outputsize` - The size of the time series to return. Either `compact` or `full`.
  """
  def fx_monthly(from_symbol, to_symbol, outputsize \\ "compact") do
    Keyword.new([
      {:function, "FX_MONTHLY"},
      {:from_symbol, from_symbol},
      {:to_symbol, to_symbol},
      {:outputsize, outputsize}
    ])
    |> get()
  end

  @doc """
  Fetches the crypto exchange rate for a given currency pair.

  ## Required

  * `from_symbol` - The currency to convert from.
  * `to_symbol` - The currency to convert to.
  """
  def crypto_exchange_rates(from_symbol, to_symbol) do
    Keyword.new([
      {:function, "CURRENCY_EXCHANGE_RATE"},
      {:from_currency, from_symbol},
      {:to_currency, to_symbol}
    ])
    |> get()
  end

  @doc """
  Fetches the intraday crypto exchange rate for a given currency pair.

  ## Required

  * `symbol` - The currency to convert from.
  * `market` - The currency to convert to.
  * `interval` - The interval between two consecutive data points in the time series.

  ## Optional

  * `outputsize` - The size of the time series to return. Either `compact` or `full`.
  """
  def crypto_intraday(symbol, market, interval, outputsize \\ "compact") do
    Keyword.new([
      {:function, "DIGITAL_CURRENCY_INTRADAY"},
      {:symbol, symbol},
      {:market, market},
      {:interval, interval},
      {:outputsize, outputsize}
    ])
    |> get()
  end

  @doc """
  Fetches the daily crypto exchange rate for a given currency pair.

  ## Required

  * `symbol` - The currency to convert from.
  * `market` - The currency to convert to.

  ## Optional

  * `outputsize` - The size of the time series to return. Either `compact` or `full`.
  """
  def crypto_daily(symbol, market, outputsize \\ "compact") do
    Keyword.new([
      {:function, "DIGITAL_CURRENCY_DAILY"},
      {:symbol, symbol},
      {:market, market},
      {:outputsize, outputsize}
    ])
    |> get()
  end

  @doc """
  Fetches the weekly crypto exchange rate for a given currency pair.

  ## Required

  * `symbol` - The currency to convert from.
  * `market` - The currency to convert to.

  ## Optional

  * `outputsize` - The size of the time series to return. Either `compact` or `full`.
  """
  def crypto_weekly(symbol, market, outputsize \\ "compact") do
    Keyword.new([
      {:function, "DIGITAL_CURRENCY_WEEKLY"},
      {:symbol, symbol},
      {:market, market},
      {:outputsize, outputsize}
    ])
    |> get()
  end

  @doc """
  Fetches the monthly crypto exchange rate for a given currency pair.

  ## Required

  * `symbol` - The currency to convert from.
  * `market` - The currency to convert to.

  ## Optional

  * `outputsize` - The size of the time series to return. Either `compact` or `full`.
  """
  def crypto_monthly(symbol, market, outputsize \\ "compact") do
    Keyword.new([
      {:function, "DIGITAL_CURRENCY_MONTHLY"},
      {:symbol, symbol},
      {:market, market},
      {:outputsize, outputsize}
    ])
    |> get()
  end

  @doc """
  Fetches the prices for WTI crude oil.

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def wti(interval \\ "monthly") do
    Keyword.new([{:function, "WTI"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the prices for Brent crude oil.

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def brent(interval \\ "monthly") do
    Keyword.new([{:function, "BRENT"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the prices for natural gas.

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def natural_gas(interval \\ "monthly") do
    Keyword.new([{:function, "NATURAL_GAS"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the prices for copper.

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def copper(interval \\ "monthly") do
    Keyword.new([{:function, "COPPER"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the prices for aluminum.

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def aluminum(interval \\ "monthly") do
    Keyword.new([{:function, "ALUMINUM"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the prices for wheat

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def wheat(interval \\ "monthly") do
    Keyword.new([{:function, "WHEAT"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the prices for corn

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def corn(interval \\ "monthly") do
    Keyword.new([{:function, "CORN"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the prices for cotton

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def cotton(interval \\ "monthly") do
    Keyword.new([{:function, "COTTON"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the prices for sugar

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def sugar(interval \\ "monthly") do
    Keyword.new([{:function, "SUGAR"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the prices for coffee

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def coffee(interval \\ "monthly") do
    Keyword.new([{:function, "COFFEE"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the prices for commodities index

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def commodities(interval \\ "monthly") do
    Keyword.new([{:function, "ALL_COMMODITIES"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the real GDP of the United States.

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def real_gdp(interval \\ "annual") do
    Keyword.new([{:function, "REAL_GDP"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the real GDP per capita of the United States.

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def real_gdp_per_capita do
    Keyword.new([{:function, "REAL_GDP_PER_CAPITA"}]) |> get()
  end

  @doc """
  Fetches the treasury yield of the United States.

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  * `maturity` - The maturity of treasury yield.
  """
  def treasury_yield(interval \\ "daily", maturity \\ "10year") do
    Keyword.new([{:function, "TREASURY_YIELD"}, {:interval, interval}, {:maturity, maturity}])
    |> get()
  end

  @doc """
  Fetches the federal funds rate of the United States.

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def federal_funds_rate(interval \\ "monthly") do
    Keyword.new([{:function, "FEDERAL_FUNDS_RATE"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the consumer price index of the United States.

  ## Optional

  * `interval` - The interval between two consecutive data points in the time series.
  """
  def cpi(interval \\ "monthly") do
    Keyword.new([{:function, "CPI"}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the inflation rate of the United States.
  """
  def inflation do
    Keyword.new([{:function, "INFLATION"}]) |> get()
  end

  @doc """
  Fetches the retail sales of the United States.
  """
  def retail_sales do
    Keyword.new([{:function, "RETAIL_SALES"}]) |> get()
  end

  @doc """
  Fetches the durable goods orders of the United States.
  """
  def durable_goods_orders do
    Keyword.new([{:function, "DURABLES"}]) |> get()
  end

  @doc """
  Fetches the unemployment rate of the United States.
  """
  def unemployment_rate do
    Keyword.new([{:function, "UNEMPLOYMENT"}]) |> get()
  end

  @doc """
  Fetches the nonfarm payroll of the United States.
  """
  def nonfarm_payroll do
    Keyword.new([{:function, "NONFARM_PAYROLL"}]) |> get()
  end

  @doc """
  Fetches simple moving average values for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each moving average value.
  * `series_type` - The desired price type in the time series.
  """
  def sma(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "SMA"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches exponential moving average values for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each moving average value.
  * `series_type` - The desired price type in the time series.
  """
  def ema(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "EMA"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches weighted moving average values for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each moving average value.
  * `series_type` - The desired price type in the time series.
  """
  def wma(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "WMA"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches double exponential moving average values for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each moving average value.
  * `series_type` - The desired price type in the time series.
  """
  def dema(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "DEMA"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches triple exponential moving average values for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each moving average value.
  * `series_type` - The desired price type in the time series.
  """
  def tema(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "TEMA"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches triangular moving average values for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each moving average value.
  * `series_type` - The desired price type in the time series.
  """
  def trima(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "TRIMA"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches Kaufman adaptive moving average values for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each moving average value.
  * `series_type` - The desired price type in the time series.
  """
  def kama(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "KAMA"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the MESA adaptive moving average values for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each moving average value.
  * `series_type` - The desired price type in the time series.
  """
  def mama(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "MAMA"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the volume weighted average price.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  """
  def vwap(symbol, interval) do
    Keyword.new([{:function, "VWAP"}, {:symbol, symbol}, {:interval, interval}])
    |> get()
  end

  @doc """
  Fetches the triple exponential moving average values for a given symbol.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each moving average value.
  * `series_type` - The desired price type in the time series.
  """
  def t3(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "T3"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the moving average convergence / divergence values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `series_type` - The desired price type in the time series.

  ## Optional

  * `fastperiod` - The time period of the fast EMA.
  * `slowperiod` - The time period of the slow EMA.
  * `signalperiod` - The time period of the signal EMA.
  """
  def macd(symbol, interval, series_type, opts \\ []) do
    Keyword.new([
      {:function, "MACD"},
      {:symbol, symbol},
      {:interval, interval},
      {:series_type, series_type}
    ])
    |> Keyword.merge(opts)
    |> get()
  end

  @doc """
  Fetches the moving average convergence / divergence values with controllable moving average type.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `series_type` - The desired price type in the time series.

  ## Optional

  * `fastperiod` - The time period of the fast EMA.
  * `slowperiod` - The time period of the slow EMA.
  * `signalperiod` - The time period of the signal EMA.
  """
  def macdext(symbol, interval, series_type, opts \\ []) do
    Keyword.new([
      {:function, "MACDEXT"},
      {:symbol, symbol},
      {:interval, interval},
      {:series_type, series_type}
    ])
    |> Keyword.merge(opts)
    |> get()
  end

  @doc """
  Fetches the  stochastic oscillator values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.

  ## Optional

  * `fastkperiod` - The time period of the fastk moving average.
  * `slowkperiod` - The time period of the slowk moving average.
  * `slowdperiod` - The time period of the slowd moving average.
  * `slowkmatype` - The type of moving average for the slowk moving average.
  * `slowdmatype` - The type of moving average for the slowd moving average.
  """
  def stoch(symbol, interval, opts \\ []) do
    Keyword.new([{:function, "STOCH"}, {:symbol, symbol}, {:interval, interval}])
    |> Keyword.merge(opts)
    |> get()
  end

  @doc """
  Fetches the stochastic oscillator fast values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.

  ## Optional

  * `fastkperiod` - The time period of the fastk moving average.
  * `fastdperiod` - The time period of the fastd moving average.
  * `fastdmatype` - The type of moving average for the fastd moving average.
  """
  def stochf(symbol, interval, opts \\ []) do
    Keyword.new([{:function, "STOCHF"}, {:symbol, symbol}, {:interval, interval}])
    |> Keyword.merge(opts)
    |> get()
  end

  @doc """
  Fetches the relative strength index values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each RSI value.
  * `series_type` - The desired price type in the time series.
  """
  def rsi(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "RSI"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the stochastic relative strength index values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each RSI value.
  * `series_type` - The desired price type in the time series.

  ## Optional

  * `fastkperiod` - The time period of the fastk moving average.
  * `fastdperiod` - The time period of the fastd moving average.
  * `fastdmatype` - The type of moving average for the fastd moving average.
  """
  def stochrsi(symbol, interval, time_period, series_type, opts \\ []) do
    Keyword.new([
      {:function, "STOCHRSI"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> Keyword.merge(opts)
    |> get()
  end

  @doc """
  Fetches the Williams' %R values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each Williams' %R value.
  """
  def willr(symbol, interval, time_period) do
    Keyword.new([
      {:function, "WILLR"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the average directional movement index values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each ADX value.
  """
  def adx(symbol, interval, time_period) do
    Keyword.new([
      {:function, "ADX"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the average directional movement index rating values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each ADXR value.
  """
  def adxr(symbol, interval, time_period) do
    Keyword.new([
      {:function, "ADXR"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the absolute price oscillator values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `series_type` - The desired price type in the time series.

  ## Optional

  * `fastperiod` - The time period of the fast EMA.
  * `slowperiod` - The time period of the slow EMA.
  * `matype` - The type of moving average to be used.
  """
  def apo(symbol, interval, series_type, opts \\ []) do
    Keyword.new([
      {:function, "APO"},
      {:symbol, symbol},
      {:interval, interval},
      {:series_type, series_type}
    ])
    |> Keyword.merge(opts)
    |> get()
  end

  @doc """
  Fetches the percentage price oscillator values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `series_type` - The desired price type in the time series.

  ## Optional

  * `fastperiod` - The time period of the fast EMA.
  * `slowperiod` - The time period of the slow EMA.
  * `matype` - The type of moving average to be used.
  """
  def ppo(symbol, interval, series_type, opts \\ []) do
    Keyword.new([
      {:function, "PPO"},
      {:symbol, symbol},
      {:interval, interval},
      {:series_type, series_type}
    ])
    |> Keyword.merge(opts)
    |> get()
  end

  @doc """
  Fetches the momentum values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  * `series_type` - The desired price type in the time series.
  """
  def mom(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "MOM"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the balance of power values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  """
  def bop(symbol, interval) do
    Keyword.new([{:function, "BOP"}, {:symbol, symbol}, {:interval, interval}])
    |> get()
  end

  @doc """
  Fetches the commodity channel index values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  """
  def cci(symbol, interval, time_period) do
    Keyword.new([
      {:function, "CCI"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the Chande momentum oscillator values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  * `series_type` - The desired price type in the time series.
  """
  def cmo(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "CMO"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the rate of change values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  * `series_type` - The desired price type in the time series.
  """
  def roc(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "ROC"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the rate of change ratio values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  * `series_type` - The desired price type in the time series.
  """
  def rocr(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "ROCR"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the Aroon indicator values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  """
  def aroon(symbol, interval, time_period) do
    Keyword.new([
      {:function, "AROON"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the Aroon oscillator values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  """
  def aroonosc(symbol, interval, time_period) do
    Keyword.new([
      {:function, "AROONOSC"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the money flow index values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  """
  def mfi(symbol, interval, time_period) do
    Keyword.new([
      {:function, "MFI"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the 1-day rate of change of a triple smooth exponential moving average values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  * `series_type` - The desired price type in the time series.
  """
  def trix(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "TRIX"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the ultimate oscillator values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.

  ## Optional

  * `timeperiod1` - The number of data points used to calculate the first momentum value.
  * `timeperiod2` - The number of data points used to calculate the second momentum value.
  * `timeperiod3` - The number of data points used to calculate the third momentum value.
  """
  def ultosc(symbol, interval, opts \\ []) do
    Keyword.new([{:function, "ULTOSC"}, {:symbol, symbol}, {:interval, interval}])
    |> Keyword.merge(opts)
    |> get()
  end

  @doc """
  Fetches the direction movement index values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  """
  def dx(symbol, interval, time_period) do
    Keyword.new([
      {:function, "DX"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the minus directional indicator values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  """
  def minus_di(symbol, interval, time_period) do
    Keyword.new([
      {:function, "MINUS_DI"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the plus directional indicator values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  """
  def plus_di(symbol, interval, time_period) do
    Keyword.new([
      {:function, "PLUS_DI"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the minus directional movement values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  """
  def minus_dm(symbol, interval, time_period) do
    Keyword.new([
      {:function, "MINUS_DM"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the plus directional movement values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  """
  def plus_dm(symbol, interval, time_period) do
    Keyword.new([
      {:function, "PLUS_DM"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the bollinger bands values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.

  ## Optional

  * `ndbevup` - The number of standard deviations above the upper band.
  * `nbdevdn` - The number of standard deviations below the lower band.
  * `matype` - The type of moving average to use.
  """
  def bbands(symbol, interval, time_period, series_type, opts \\ []) do
    Keyword.new([
      {:function, "BBANDS"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> Keyword.merge(opts)
    |> get()
  end

  @doc """
  Fetches the midpoint

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  * `series_type` - The desired price type in the time series.
  """
  def midpoint(symbol, interval, time_period, series_type) do
    Keyword.new([
      {:function, "MIDPOINT"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the midpoint price values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  """
  def midprice(symbol, interval, time_period) do
    Keyword.new([
      {:function, "MIDPRICE"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the parabolic sar values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.

  ## Optional

  * `acceleration` - The acceleration factor.
  * `maximum` - The maximum acceleration factor.
  """
  def sar(symbol, interval, opts \\ []) do
    Keyword.new([{:function, "SAR"}, {:symbol, symbol}, {:interval, interval}])
    |> Keyword.merge(opts)
    |> get()
  end

  @doc """
  Fetches the true range values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  """
  def trange(symbol, interval) do
    Keyword.new([{:function, "TRANGE"}, {:symbol, symbol}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the average true range values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  """
  def atr(symbol, interval, time_period) do
    Keyword.new([
      {:function, "ATR"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the normalized average true range values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `time_period` - The number of data points used to calculate each momentum value.
  """
  def natr(symbol, interval, time_period) do
    Keyword.new([
      {:function, "NATR"},
      {:symbol, symbol},
      {:interval, interval},
      {:time_period, time_period}
    ])
    |> get()
  end

  @doc """
  Fetches the Chaikin A/D line values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  """
  def ad(symbol, interval) do
    Keyword.new([{:function, "AD"}, {:symbol, symbol}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the Chaikin A/D oscillator values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.

  ## Optional

  * `fastperiod` - The time period of the fast Aroon oscillator.
  * `slowperiod` - The time period of the slow Aroon oscillator.
  """
  def adosc(symbol, interval, opts \\ []) do
    Keyword.new([{:function, "ADOSC"}, {:symbol, symbol}, {:interval, interval}])
    |> Keyword.merge(opts)
    |> get()
  end

  @doc """
  Fetches the on balance volume values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  """
  def obv(symbol, interval) do
    Keyword.new([{:function, "OBV"}, {:symbol, symbol}, {:interval, interval}]) |> get()
  end

  @doc """
  Fetches the Hilbert transform, instantaneous trendline values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `series_type` - The desired price type in the time series.
  """
  def ht_trendline(symbol, interval, series_type) do
    Keyword.new([
      {:function, "HT_TRENDLINE"},
      {:symbol, symbol},
      {:interval, interval},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the Hilbert transform, sine wave values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `series_type` - The desired price type in the time series.
  """
  def ht_sine(symbol, interval, series_type) do
    Keyword.new([
      {:function, "HT_SINE"},
      {:symbol, symbol},
      {:interval, interval},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the Hilbert transform, trend vs cycle mode values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `series_type` - The desired price type in the time series.
  """
  def ht_trendmode(symbol, interval, series_type) do
    Keyword.new([
      {:function, "HT_TRENDMODE"},
      {:symbol, symbol},
      {:interval, interval},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the Hilbert transform, dominant cycle period values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `series_type` - The desired price type in the time series.
  """
  def ht_dcperiod(symbol, interval, series_type) do
    Keyword.new([
      {:function, "HT_DCPERIOD"},
      {:symbol, symbol},
      {:interval, interval},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the Hilbert transform, dominant cycle phase values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `series_type` - The desired price type in the time series.
  """
  def ht_dcphase(symbol, interval, series_type) do
    Keyword.new([
      {:function, "HT_DCPHASE"},
      {:symbol, symbol},
      {:interval, interval},
      {:series_type, series_type}
    ])
    |> get()
  end

  @doc """
  Fetches the Hilbert transform, phasor components values.

  ## Required

  * `symbol` - The stock symbol to fetch the data for.
  * `interval` - The time interval between two consecutive data points in the time series.
  * `series_type` - The desired price type in the time series.
  """
  def ht_phasor(symbol, interval, series_type) do
    Keyword.new([
      {:function, "HT_PHASOR"},
      {:symbol, symbol},
      {:interval, interval},
      {:series_type, series_type}
    ])
    |> get()
  end

  defp get(params) do
    SimpleRateLimiter.wait_and_proceed(fn ->
      api_key = Application.get_env(:alpha_vantage_client, :api_key)
      params = params |> Keyword.put(:apikey, api_key)

      case Req.get("https://www.alphavantage.co/query", params: params) do
        {:ok, %Req.Response{status: 200, body: body}} ->
          case body do
            %{"Error Message" => message} ->
              {:error, message}

            data ->
              {:ok, data}
          end

        {:ok, %Req.Response{status: code}} ->
          {:error, "unexpected response code: #{code}"}

        {:error, error} ->
          {:error, error}
      end
    end)
  end
end
