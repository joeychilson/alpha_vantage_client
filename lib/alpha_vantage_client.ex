defmodule AlphaVantage do
  use Application

  @base_url "https://www.alphavantage.co/query"

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

  ## Inputs

  * `symbol` - The stock symbol to fetch the time series for.
  * `interval` - The interval to fetch the time series for.

  ## Parameters

  * `adjusted` - If true, the adjusted time series is returned.
  * `extended_hours` - If true, the extended hours time series is returned.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Intraday (1min) open, high, low, close prices and volume",
      "2. Symbol" => "AAPL",
      "3. Last Refreshed" => "2023-06-28 19:59:00",
      "4. Interval" => "1min",
      "5. Output Size" => "Full size",
      "6. Time Zone" => "US/Eastern"
    },
    "Time Series (1min)" => %{
      "2023-06-28 09:43:00" => %{
        "1. open" => "188.4720",
        "2. high" => "188.6300",
        "3. low" => "188.4400",
        "4. close" => "188.6000",
        "5. volume" => "260376"
      },
    }
  }
  ```
  """
  def time_series_intraday(symbol, interval, params \\ %{}),
    do:
      get(
        Map.merge(%{function: "TIME_SERIES_INTRADAY", symbol: symbol, interval: interval}, params)
      )

  @doc """
  Fetches the daily time series for a given symbol.

  ## Inputs

  * `symbol` - The stock symbol to fetch the time series for.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Daily Prices (open, high, low, close) and Volumes",
      "2. Symbol" => "IBM",
      "3. Last Refreshed" => "2023-06-28",
      "4. Output Size" => "Compact",
      "5. Time Zone" => "US/Eastern"
    },
    "Time Series (Daily)" => %{
      "2023-06-28" => %{
        "1. open" => "132.0600",
        "2. high" => "132.1700",
        "3. low" => "130.9100",
        "4. close" => "131.7600",
        "5. volume" => "2753779"
      },
    }
  }
  ```
  """
  def time_series_daily(symbol, outputsize \\ "compact"),
    do: get(%{function: "TIME_SERIES_DAILY", symbol: symbol, outputsize: outputsize})

  @doc """
  Fetches the daily adjusted time series for a given symbol.

  ## Inputs

  * `symbol` - The stock symbol to fetch the time series for.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Daily Time Series with Splits and Dividend Events",
      "2. Symbol" => "AAPL",
      "3. Last Refreshed" => "2023-06-28",
      "4. Output Size" => "Compact",
      "5. Time Zone" => "US/Eastern"
    },
    "Time Series (Daily)" => %{
      "2023-02-10" => %{
        "1. open" => "149.46",
        "2. high" => "151.3401",
        "3. low" => "149.22",
        "4. close" => "151.01",
        "5. adjusted close" => "150.800276025693",
        "6. volume" => "57450708",
        "7. dividend amount" => "0.2300",
        "8. split coefficient" => "1.0"
      },
    }
  }
  ```
  """
  def time_series_daily_adjusted(symbol, outputsize \\ "compact"),
    do: get(%{function: "TIME_SERIES_DAILY_ADJUSTED", symbol: symbol, outputsize: outputsize})

  @doc """
  Fetches the weekly time series for a given symbol.

  ## Inputs

  * `symbol` - The stock symbol to fetch the time series for.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Weekly Prices (open, high, low, close) and Volumes",
      "2. Symbol" => "AAPL",
      "3. Last Refreshed" => "2023-06-28",
      "4. Time Zone" => "US/Eastern"
    },
    "Weekly Time Series" => %{
      "2010-07-30" => %{
        "1. open" => "260.0000",
        "2. high" => "265.9900",
        "3. low" => "254.9000",
        "4. close" => "257.2500",
        "5. volume" => "93475900"
      },
    }
  }
  ```
  """
  def time_series_weekly(symbol),
    do: get(%{function: "TIME_SERIES_WEEKLY", symbol: symbol})

  @doc """
  Fetches the weekly adjusted time series for a given symbol.

  ## Inputs

  * `symbol` - The stock symbol to fetch the time series for.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Weekly Adjusted Prices and Volumes",
      "2. Symbol" => "AAPL",
      "3. Last Refreshed" => "2023-06-28",
      "4. Time Zone" => "US/Eastern"
    },
    "Weekly Adjusted Time Series" => %{
      "2010-07-30" => %{
        "1. open" => "260.0000",
        "2. high" => "265.9900",
        "3. low" => "254.9000",
        "4. close" => "257.2500",
        "5. adjusted close" => "7.8079",
        "6. volume" => "93475900",
        "7. dividend amount" => "0.0000"
      },
    }
  }
  ```
  """
  def time_series_weekly_adjusted(symbol),
    do: get(%{function: "TIME_SERIES_WEEKLY_ADJUSTED", symbol: symbol})

  @doc """
  Fetches the monthly time series for a given symbol.

  ## Inputs

  * `symbol` - The stock symbol to fetch the time series for.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Monthly Prices (open, high, low, close) and Volumes",
      "2. Symbol" => "AAPL",
      "3. Last Refreshed" => "2023-06-28",
      "4. Time Zone" => "US/Eastern"
    },
    "Monthly Time Series" => %{
      "2010-07-30" => %{
        "1. open" => "254.3000",
        "2. high" => "265.9900",
        "3. low" => "239.6000",
        "4. close" => "257.2500",
        "5. volume" => "559632300"
      },
    }
  }
  ```
  """
  def time_series_monthly(symbol),
    do: get(%{function: "TIME_SERIES_MONTHLY", symbol: symbol})

  @doc """
  Fetches the monthly adjusted time series for a given symbol.

  ## Inputs

  * `symbol` - The stock symbol to fetch the time series for.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Monthly Adjusted Prices and Volumes",
      "2. Symbol" => "AAPL",
      "3. Last Refreshed" => "2023-06-28",
      "4. Time Zone" => "US/Eastern"
    },
    "Monthly Adjusted Time Series" => %{
      "2010-07-30" => %{
        "1. open" => "254.3000",
        "2. high" => "265.9900",
        "3. low" => "239.6000",
        "4. close" => "257.2500",
        "5. adjusted close" => "7.8079",
        "6. volume" => "559632300",
        "7. dividend amount" => "0.0000"
      },
    }
  }
  ```
  """
  def time_series_monthly_adjusted(symbol),
    do: get(%{function: "TIME_SERIES_MONTHLY_ADJUSTED", symbol: symbol})

  @doc """
  Fetches the quote for a given symbol.

  ## Inputs

  * `symbol` - The stock symbol to fetch the quote for.

  ## Response

  ```elixir
  %{
    "Global Quote" => %{
      "01. symbol" => "AAPL",
      "02. open" => "187.9300",
      "03. high" => "189.9000",
      "04. low" => "187.6000",
      "05. price" => "189.2500",
      "06. volume" => "51216801",
      "07. latest trading day" => "2023-06-28",
      "08. previous close" => "188.0600",
      "09. change" => "1.1900",
      "10. change percent" => "0.6328%"
    }
  }
  ```
  """
  def quote(symbol),
    do: get(%{function: "GLOBAL_QUOTE", symbol: symbol})

  @doc """
  Fetches the search results for a given keyword.

  ## Inputs

  * `keywords` - The keywords to search for.

  ## Response

  ```elixir
  %{
    "bestMatches" => [
      %{
        "1. symbol" => "MSF0.FRK",
        "2. name" => "MICROSOFT CORP. CDR",
        "3. type" => "Equity",
        "4. region" => "Frankfurt",
        "5. marketOpen" => "08:00",
        "6. marketClose" => "20:00",
        "7. timezone" => "UTC+02",
        "8. currency" => "EUR",
        "9. matchScore" => "0.6429"
      },
    ]
  }
  ```
  """
  def search(keywords),
    do: get(%{function: "SYMBOL_SEARCH", keywords: keywords})

  @doc """
  Fetches the market status.

  ## Response

  ```elixir
  %{
    "endpoint" => "Global Market Open & Close Status",
    "markets" => [
      %{
        "current_status" => "closed",
        "local_close" => "16:15",
        "local_open" => "09:30",
        "market_type" => "Equity",
        "notes" => "",
        "primary_exchanges" => "NASDAQ, NYSE, AMEX, BATS",
        "region" => "United States"
      },
    ]
  }
  ```
  """
  def market_status, do: get(%{function: "MARKET_STATUS"})

  @doc """
  Fetches the news sentiment

  ## Parameters

  * `tickers` - A comma-separated list of stock tickers.
  * `topics` - A comma-separated list of topics.
  * `time_from` - A date in the format  YYYYMMDDTHHMM.
  * `time_to` - A date in the format  YYYYMMDDTHHMM.
  * `sort` - The sort order of the results. Possible values are LATEST, EARLIEST, RELEVANCE.
  * `limit` - The number of results to return. Possible values are 1-1000.

  ## Response

  ```elixir
  %{
    "feed" => [
      %{
        "authors" => [],
        "banner_image" => "https://www.financialexpress.com/wp-content/uploads/2023/06/Satya-Nadella.jpg",
        "category_within_source" => "n/a",
        "overall_sentiment_label" => "Neutral",
        "overall_sentiment_score" => 0.050773,
        "source" => "The Financial Express",
        "source_domain" => "www.financialexpress.com",
        "summary" => "Microsoft CEO Nadella tells a judge his planned Activision takeover is good for gaming The Financial Express ...",
        "ticker_sentiment" => [
          %{
            "relevance_score" => "0.491399",
            "ticker" => "ATVI",
            "ticker_sentiment_label" => "Neutral",
            "ticker_sentiment_score" => "0.035327"
          },
        ],
        "time_published" => "20230629T044402",
        "title" => "Microsoft CEO Nadella tells a judge his planned Activision takeover is good for gaming | The Financial Express",
        "topics" => [
          %{
            "relevance_score" => "0.5",
            "topic" => "Technology"
          },
        ],
        "url" => "https://www.financialexpress.com/tech-trends/microsoft-ceo-nadella-tells-a-judge-his-planned-activision-takeover-is-good-for-gaming/3147293/"
      },
    ],
    "items" => "50",
    "relevance_score_definition" => "0 < x <= 1, with a higher score indicating higher relevance.",
    "sentiment_score_definition" => "x <= -0.35: Bearish;"
  }

  ```
  """
  def news_sentiment(params \\ %{}), do: get(Map.merge(%{function: "NEWS_SENTIMENT"}, params))

  @doc """
  Fetches the top gainers, losers, and most actively traded US tickers.

  ## Response

  ```elixir
  %{
    "last_updated" => "2023-06-28 16:15:59 US/Eastern",
    "metadata" => "Top gainers, losers, and most actively traded US tickers",
    "most_actively_traded" => [
      %{
        "change_amount" => "-0.0267",
        "change_percentage" => "-19.5175%",
        "price" => "0.1101",
        "ticker" => "MULN",
        "volume" => "396949152"
      },
    ],
    "top_gainers" => [
      %{
        "change_amount" => "0.0526",
        "change_percentage" => "316.8675%",
        "price" => "0.0692",
        "ticker" => "XPDBW",
        "volume" => "77067"
      },
    ],
    "top_losers" => [
      %{
        "change_amount" => "-0.0515",
        "change_percentage" => "-52.0202%",
        "price" => "0.0475",
        "ticker" => "MMVWW",
        "volume" => "3892"
      },
    ]
  }
  ```
  """
  def top_gainers_losers_and_active, do: get(%{function: "TOP_GAINERS_LOSERS"})

  @doc """
  Fetches the company overview for a given symbol.

  ## Inputs

  * `symbol` - The stock symbol to fetch the overview for.

  ## Response

  ```elixir
  %{
    "PriceToBookRatio" => "44.63",
    "EBITDA" => "123788001000",
    "OperatingMarginTTM" => "0.292",
    "Exchange" => "NASDAQ",
    "52WeekLow" => "123.81",
    "200DayMovingAverage" => "154.08",
    "Address" => "ONE INFINITE LOOP, CUPERTINO, CA, US",
    "Symbol" => "AAPL",
    "ReturnOnAssetsTTM" => "0.206",
    "RevenueTTM" => "385095008000",
    "EVToEBITDA" => "17.53",
    "QuarterlyRevenueGrowthYOY" => "-0.025",
    "DividendYield" => "0.0051",
    "PEGRatio" => "2.75",
    "QuarterlyEarningsGrowthYOY" => "0",
    "AssetType" => "Common Stock",
    "52WeekHigh" => "188.39",
    "Sector" => "TECHNOLOGY",
    "Description" => "Apple Inc. is an American multinational technology company",
    "TrailingPE" => "31.87",
    "Currency" => "USD",
    "50DayMovingAverage" => "175.14",
    "FiscalYearEnd" => "September",
    "EVToRevenue" => "5.92",
    "Name" => "Apple Inc",
    "DividendDate" => "2023-05-18",
    "SharesOutstanding" => "15728700000",
    "GrossProfitTTM" => "170782000000",
    "Country" => "USA",
    "ReturnOnEquityTTM" => "1.456",
    "ForwardPE" => "25.4",
    "RevenuePerShareTTM" => "24.12",
    "AnalystTargetPrice" => "187.11",
    "Industry" => "ELECTRONIC COMPUTERS",
    "BookValue" => "3.953",
    "ProfitMargin" => "0.245",
    "EPS" => "5.9",
    "LatestQuarter" => "2023-03-31",
    "DilutedEPSTTM" => "5.9",
    "CIK" => "320193",
    "MarketCapitalization" => "2957939311000",
    "PERatio" => "31.87",
    "DividendPerShare" => "0.92",
    "ExDividendDate" => "2023-05-12",
    "PriceToSalesRatioTTM" => "5.51",
    "Beta" => "1.289"
  }
  ```
  """
  def company_overview(symbol), do: get(%{function: "OVERVIEW", symbol: symbol})

  @doc """
  Fetches the income statements for a given symbol.

  ## Inputs

  * `symbol` - The stock symbol to fetch the income statements for.

  ## Response

  ```elixir
  %{
    "annualReports" => [
      %{
        "comprehensiveIncomeNetOfTax" => "88531000000",
        "costOfRevenue" => "248640000000",
        "costofGoodsAndServicesSold" => "223546000000",
        "depreciation" => "8700000000",
        "depreciationAndAmortization" => "11104000000",
        "ebit" => "122034000000",
        "ebitda" => "130541000000",
        "fiscalDateEnding" => "2022-09-30",
        "grossProfit" => "170782000000",
        "incomeBeforeTax" => "119103000000",
        "incomeTaxExpense" => "19300000000",
        "interestAndDebtExpense" => "2931000000",
        "interestExpense" => "2931000000",
        "interestIncome" => "106000000",
        "investmentIncomeNet" => "2825000000",
        "netIncome" => "99803000000",
        "netIncomeFromContinuingOperations" => "99803000000",
        "netInterestIncome" => "-2931000000",
        "nonInterestIncome" => "394328000000",
        "operatingExpenses" => "51345000000",
        "operatingIncome" => "119437000000",
        "otherNonOperatingIncome" => "-228000000",
        "reportedCurrency" => "USD",
        "researchAndDevelopment" => "26251000000",
        "sellingGeneralAndAdministrative" => "25094000000",
        "totalRevenue" => "391397000000"
      },
    ],
    "symbol" => "AAPL"
  }
  ```
  """
  def income_statements(symbol), do: get(%{function: "INCOME_STATEMENT", symbol: symbol})

  @doc """
  Fetches the balance sheets for a given symbol.

  ## Inputs

  * `symbol` - The stock symbol to fetch the balance sheets for.

  ## Response

  ```elixir
  %{
    "annualReports" => [
      %{
        "inventory" => "4946000000",
        "otherCurrentLiabilities" => "60845000000",
        "propertyPlantEquipment" => "42117000000",
        "goodwill" => "None",
        "totalNonCurrentAssets" => "217350000000",
        "totalLiabilities" => "302083000000",
        "longTermDebt" => "110100000000",
        "fiscalDateEnding" => "2022-09-30",
        "currentLongTermDebt" => "11128000000",
        "shortTermDebt" => "9982000000",
        "totalShareholderEquity" => "50672000000",
        "intangibleAssetsExcludingGoodwill" => "None",
        "reportedCurrency" => "USD",
        "totalAssets" => "352755000000",
        "otherCurrentAssets" => "21223000000",
        "otherNonCurrentLiabilities" => "49142000000",
        "totalCurrentLiabilities" => "153982000000",
        "investments" => "292870000000",
        "currentNetReceivables" => "60932000000",
        "capitalLeaseObligations" => "812000000",
        "currentAccountsPayable" => "64115000000",
        "commonStock" => "64849000000",
        "retainedEarnings" => "-3068000000",
        "longTermInvestments" => "120805000000",
        "commonStockSharesOutstanding" => "15943425000",
        "currentDebt" => "21239000000",
        "shortLongTermDebtTotal" => "233256000000",
        "deferredRevenue" => "20312000000",
        "treasuryStock" => "None",
        "intangibleAssets" => "None",
        "longTermDebtNoncurrent" => "98959000000",
        "shortTermInvestments" => "24658000000",
        "accumulatedDepreciationAmortizationPPE" => "72340000000",
        "cashAndCashEquivalentsAtCarryingValue" => "23646000000",
        "cashAndShortTermInvestments" => "48304000000",
        "otherNonCurrentAssets" => "54428000000",
        "totalNonCurrentLiabilities" => "148101000000",
        "totalCurrentAssets" => "135405000000"
      },
    ],
    "symbol" => "AAPL"
  }
  ```
  """
  def balance_sheets(symbol), do: get(%{function: "BALANCE_SHEET", symbol: symbol})

  @doc """
  Fetches the cash flow statements for a given symbol.

  ## Inputs

  * `symbol` - The stock symbol to fetch the cash flow statements for.

  ## Response

  ```elixir
  %{
    "annualReports" => [
      %{
        "capitalExpenditures" => "10708000000",
        "cashflowFromFinancing" => "-110749000000",
        "cashflowFromInvestment" => "-22354000000",
        "changeInCashAndCashEquivalents" => "-10952000000",
        "changeInExchangeRate" => "None",
        "changeInInventory" => "-1484000000",
        "changeInOperatingAssets" => "14358000000",
        "changeInOperatingLiabilities" => "15558000000",
        "changeInReceivables" => "9343000000",
        "depreciationDepletionAndAmortization" => "11104000000",
        "dividendPayout" => "14841000000",
        "dividendPayoutCommonStock" => "14841000000",
        "dividendPayoutPreferredStock" => "None",
        "fiscalDateEnding" => "2022-09-30",
        "netIncome" => "99803000000",
        "operatingCashflow" => "122151000000",
        "paymentsForOperatingActivities" => "4665000000",
        "paymentsForRepurchaseOfCommonStock" => "89402000000",
        "paymentsForRepurchaseOfEquity" => "89402000000",
        "paymentsForRepurchaseOfPreferredStock" => "None",
        "proceedsFromIssuanceOfCommonStock" => "None",
        "proceedsFromIssuanceOfLongTermDebtAndCapitalSecuritiesNet" => "5465000000",
        "proceedsFromIssuanceOfPreferredStock" => "None",
        "proceedsFromOperatingActivities" => "None",
        "proceedsFromRepaymentsOfShortTermDebt" => "7910000000",
        "proceedsFromRepurchaseOfEquity" => "-89402000000",
        "proceedsFromSaleOfTreasuryStock" => "None",
        "profitLoss" => "99803000000",
        "reportedCurrency" => "USD"
      },
    ],
    "symbol" => "AAPL"
  }
  ```
  """
  def cash_flow_statements(symbol), do: get(%{function: "CASH_FLOW", symbol: symbol})

  @doc """
  Fetches the earnings for a given symbol.

  ## Inputs

  * `symbol` - The stock symbol to fetch the earnings for.

  ## Response

  ```elixir
  %{
    "annualEarnings" => [
      %{
        "fiscalDateEnding" => "2023-03-31",
        "reportedEPS" => "3.4"
      },
    ],
    "quarterlyEarnings" => [
      %{
        "estimatedEPS" => "1.43",
        "fiscalDateEnding" => "2023-03-31",
        "reportedDate" => "2023-05-04",
        "reportedEPS" => "1.52",
        "surprise" => "0.09",
        "surprisePercentage" => "6.2937"
      },
    ],
    "symbol" => "AAPL"
  }
  ```
  """
  def earnings(symbol), do: get(%{function: "EARNINGS", symbol: symbol})

  @doc """
  Fetches the current exchange rate for a given currency pair.

  ## Inputs

  * `from_currency` - The currency to convert from.
  * `to_currency` - The currency to convert to.

  ## Response

  ```elixir
  %{
    "Realtime Currency Exchange Rate" => %{
      "1. From_Currency Code" => "USD",
      "2. From_Currency Name" => "United States Dollar",
      "3. To_Currency Code" => "EUR",
      "4. To_Currency Name" => "Euro",
      "5. Exchange Rate" => "0.91760000",
      "6. Last Refreshed" => "2023-06-29 06:04:42",
      "7. Time Zone" => "UTC",
      "8. Bid Price" => "0.91757000",
      "9. Ask Price" => "0.91761000"
    }
  }
  ```
  """
  def fx_exchange_rates(from_currency, to_currency),
    do:
      get(%{
        function: "CURRENCY_EXCHANGE_RATE",
        from_currency: from_currency,
        to_currency: to_currency
      })

  @doc """
  Fetches the intraday exchange rate for a given currency pair.

  ## Inputs

  * `from_symbol` - The currency to convert from.
  * `to_symbol` - The currency to convert to.
  * `interval` - The interval between two consecutive data points in the time series.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "FX Intraday (5min) Time Series",
      "2. From Symbol" => "EUR",
      "3. To Symbol" => "USD",
      "4. Last Refreshed" => "2023-06-29 06:40:00",
      "5. Interval" => "5min",
      "6. Output Size" => "Compact",
      "7. Time Zone" => "UTC"
    },
    "Time Series FX (5min)" => %{
      "2023-06-29 06:40:00" => %{
        "1. open" => "1.08923",
        "2. high" => "1.08967",
        "3. low" => "1.08910",
        "4. close" => "1.08962"
      },
    }
  }
  ```
  """
  def fx_intraday(from_symbol, to_symbol, interval, outputsize \\ "compact"),
    do:
      get(%{
        function: "FX_INTRADAY",
        from_symbol: from_symbol,
        to_symbol: to_symbol,
        interval: interval,
        outputsize: outputsize
      })

  @doc """
  Fetches the daily exchange rate for a given currency pair.

  ## Inputs

  * `from_symbol` - The currency to convert from.
  * `to_symbol` - The currency to convert to.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Forex Daily Prices (open, high, low, close)",
      "2. From Symbol" => "EUR",
      "3. To Symbol" => "USD",
      "4. Output Size" => "Compact",
      "5. Last Refreshed" => "2023-06-29 06:50:00",
      "6. Time Zone" => "UTC"
    },
    "Time Series FX (Daily)" => %{
      "2018-07-02" => %{
        "1. open" => "1.16736",
        "2. high" => "1.16824",
        "3. low" => "1.15900",
        "4. close" => "1.16390"
      },
    }
  }
  ```
  """
  def fx_daily(from_symbol, to_symbol, outputsize \\ "compact"),
    do:
      get(%{
        function: "FX_DAILY",
        from_symbol: from_symbol,
        to_symbol: to_symbol,
        outputsize: outputsize
      })

  @doc """
  Fetches the weekly exchange rate for a given currency pair.

  ## Inputs

  * `from_symbol` - The currency to convert from.
  * `to_symbol` - The currency to convert to.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Forex Weekly Prices (open, high, low, close)",
      "2. From Symbol" => "EUR",
      "3. To Symbol" => "USD",
      "4. Last Refreshed" => "2023-06-29 06:50:00",
      "5. Time Zone" => "UTC"
    },
    "Time Series FX (Weekly)" => %{
      "2010-07-30" => %{
        "1. open" => "1.28960",
        "2. high" => "1.31070",
        "3. low" => "1.28740",
        "4. close" => "1.30500"
      },
    }
  }
  ```
  """
  def fx_weekly(from_symbol, to_symbol, outputsize \\ "compact"),
    do:
      get(%{
        function: "FX_WEEKLY",
        from_symbol: from_symbol,
        to_symbol: to_symbol,
        outputsize: outputsize
      })

  @doc """
  Fetches the monthly exchange rate for a given currency pair.

  ## Inputs

  * `from_symbol` - The currency to convert from.
  * `to_symbol` - The currency to convert to.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Forex Monthly Prices (open, high, low, close)",
      "2. From Symbol" => "EUR",
      "3. To Symbol" => "USD",
      "4. Last Refreshed" => "2023-06-29 06:50:00",
      "5. Time Zone" => "UTC"
    },
    "Time Series FX (Monthly)" => %{
      "2010-07-30" => %{
        "1. open" => "1.22330",
        "2. high" => "1.31070",
        "3. low" => "1.21910",
        "4. close" => "1.30500"
      },
    }
  }
  ```
  """
  def fx_monthly(from_symbol, to_symbol, outputsize \\ "compact"),
    do:
      get(%{
        function: "FX_MONTHLY",
        from_symbol: from_symbol,
        to_symbol: to_symbol,
        outputsize: outputsize
      })

  @doc """
  Fetches the crypto exchange rate for a given currency pair.

  ## Inputs

  * `from_symbol` - The currency to convert from.
  * `to_symbol` - The currency to convert to.

  ## Response

  ```elixir
  %{
    "Realtime Currency Exchange Rate" => %{
      "1. From_Currency Code" => "BTC",
      "2. From_Currency Name" => "Bitcoin",
      "3. To_Currency Code" => "USD",
      "4. To_Currency Name" => "United States Dollar",
      "5. Exchange Rate" => "30234.14000000",
      "6. Last Refreshed" => "2023-06-29 06:50:01",
      "7. Time Zone" => "UTC",
      "8. Bid Price" => "30234.13000000",
      "9. Ask Price" => "30234.14000000"
    }
  }
  ```
  """
  def crypto_exchange_rates(from_symbol, to_symbol),
    do:
      get(%{
        function: "CURRENCY_EXCHANGE_RATE",
        from_currency: from_symbol,
        to_currency: to_symbol
      })

  @doc """
  Fetches the intraday crypto exchange rate for a given currency pair.

  ## Inputs

  * `symbol` - The currency to convert from.
  * `market` - The currency to convert to.
  * `interval` - The interval between two consecutive data points in the time series.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Crypto Intraday (5min) Time Series",
      "2. Digital Currency Code" => "ETH",
      "3. Digital Currency Name" => "Ethereum",
      "4. Market Code" => "USD",
      "5. Market Name" => "United States Dollar",
      "6. Last Refreshed" => "2023-06-29 06:55:00",
      "7. Interval" => "5min",
      "8. Output Size" => "Compact",
      "9. Time Zone" => "UTC"
    },
    "Time Series Crypto (5min)": %{
      "2023-06-29 06:55:00" => %{
        "1. open" => "1838.83000",
        "2. high" => "1838.83000",
        "3. low" => "1838.01000",
        "4. close" => "1838.19000",
        "5. volume" => 56
      },
    }
  }
  ```
  """
  def crypto_intraday(symbol, market, interval, outputsize \\ "compact"),
    do:
      get(%{
        function: "CRYPTO_INTRADAY",
        symbol: symbol,
        market: market,
        interval: interval,
        outputsize: outputsize
      })

  @doc """
  Fetches the daily crypto exchange rate for a given currency pair.

  ## Inputs

  * `symbol` - The currency to convert from.
  * `market` - The currency to convert to.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Daily Prices and Volumes for Digital Currency",
      "2. Digital Currency Code" => "BTC",
      "3. Digital Currency Name" => "Bitcoin",
      "4. Market Code" => "USD",
      "5. Market Name" => "United States Dollar",
      "6. Last Refreshed" => "2023-06-29 00:00:00",
      "7. Time Zone" => "UTC"
    },
    "Time Series (Digital Currency Daily)" => %{
      "2023-01-21" => %{
        "1a. open (USD)" => "22666.00000000",
        "1b. open (USD)" => "22666.00000000",
        "2a. high (USD)" => "23371.80000000",
        "2b. high (USD)" => "23371.80000000",
        "3a. low (USD)" => "22422.00000000",
        "3b. low (USD)" => "22422.00000000",
        "4a. close (USD)" => "22783.55000000",
        "4b. close (USD)" => "22783.55000000",
        "5. volume" => "346445.48432000",
        "6. market cap (USD)" => "346445.48432000"
      },
    }
  }
  ```
  """
  def crypto_daily(symbol, market, outputsize \\ "compact"),
    do:
      get(%{
        function: "DIGITAL_CURRENCY_DAILY",
        symbol: symbol,
        market: market,
        outputsize: outputsize
      })

  @doc """
  Fetches the weekly crypto exchange rate for a given currency pair.

  ## Inputs

  * `symbol` - The currency to convert from.
  * `market` - The currency to convert to.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Weekly Prices and Volumes for Digital Currency",
      "2. Digital Currency Code" => "BTC",
      "3. Digital Currency Name" => "Bitcoin",
      "4. Market Code" => "USD",
      "5. Market Name" => "United States Dollar",
      "6. Last Refreshed" => "2023-06-29 00:00:00",
      "7. Time Zone" => "UTC"
    },
    "Time Series (Digital Currency Weekly)" => %{
      "2022-05-01" => %{
        "1a. open (USD)" => "39450.12000000",
        "1b. open (USD)" => "39450.12000000",
        "2a. high (USD)" => "40797.31000000",
        "2b. high (USD)" => "40797.31000000",
        "3a. low (USD)" => "37386.38000000",
        "3b. low (USD)" => "37386.38000000",
        "4a. close (USD)" => "38468.35000000",
        "4b. close (USD)" => "38468.35000000",
        "5. volume" => "368444.26814000",
        "6. market cap (USD)" => "368444.26814000"
      },
    }
  }
  ```
  """
  def crypto_weekly(symbol, market, outputsize \\ "compact"),
    do:
      get(%{
        function: "DIGITAL_CURRENCY_WEEKLY",
        symbol: symbol,
        market: market,
        outputsize: outputsize
      })

  @doc """
  Fetches the monthly crypto exchange rate for a given currency pair.

  ## Inputs

  * `symbol` - The currency to convert from.
  * `market` - The currency to convert to.
  * `outputsize` - The size of the time series to return. Either `compact` or `full`.

  ## Response

  ```elixir
  %{
    "Meta Data" => %{
      "1. Information" => "Monthly Prices and Volumes for Digital Currency",
      "2. Digital Currency Code" => "BTC",
      "3. Digital Currency Name" => "Bitcoin",
      "4. Market Code" => "USD",
      "5. Market Name" => "United States Dollar",
      "6. Last Refreshed" => "2023-06-29 00:00:00",
      "7. Time Zone" => "UTC"
    },
    "Time Series (Digital Currency Monthly)" => %{
      "2020-11-30" => %{
        "1a. open (USD)" => "13791.00000000",
        "1b. open (USD)" => "13791.00000000",
        "2a. high (USD)" => "19863.16000000",
        "2b. high (USD)" => "19863.16000000",
        "3a. low (USD)" => "13195.05000000",
        "3b. low (USD)" => "13195.05000000",
        "4a. close (USD)" => "19695.87000000",
        "4b. close (USD)" => "19695.87000000",
        "5. volume" => "2707064.91116500",
        "6. market cap (USD)" => "2707064.91116500"
      },
    }
  }
  ```
  """
  def crypto_monthly(symbol, market, outputsize \\ "compact"),
    do:
      get(%{
        function: "DIGITAL_CURRENCY_MONTHLY",
        symbol: symbol,
        market: market,
        outputsize: outputsize
      })

  @doc """
  Fetches the prices for WTI crude oil.

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "71.58"
      },
    ],
    "interval" => "monthly",
    "name" => "Crude Oil Prices WTI",
    "unit" => "dollars per barrel"
  }
  ```
  """
  def wti(interval \\ "monthly"), do: get(%{function: "WTI", interval: interval})

  @doc """
  Fetches the prices for Brent crude oil.

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "75.47"
      },
    ],
    "interval" => "monthly",
    "name" => "Crude Oil Prices Brent",
    "unit" => "dollars per barrel"
  }
  ```
  """
  def brent(interval \\ "monthly"), do: get(%{function: "BRENT", interval: interval})

  @doc """
  Fetches the prices for natural gas.

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "2.15"
      },
    ],
    "interval" => "monthly",
    "name" => "Henry Hub Natural Gas Spot Price",
    "unit" => "dollars per million BTU"
  }
  ```
  """
  def natural_gas(interval \\ "monthly"), do: get(%{function: "NATURAL_GAS", interval: interval})

  @doc """
  Fetches the prices for copper.

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "8243.15608695652"
      },
    ],
    "interval" => "monthly",
    "name" => "Global Price of Copper",
    "unit" => "dollar per metric ton"
  }
  ```
  """
  def copper(interval \\ "monthly"), do: get(%{function: "COPPER", interval: interval})

  @doc """
  Fetches the prices for aluminum.

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "2274.01260869565"
      },
    ],
    "interval" => "monthly",
    "name" => "Global Price of Aluminum",
    "unit" => "dollar per metric ton"
  }
  ```
  """
  def aluminum(interval \\ "monthly"), do: get(%{function: "ALUMINUM", interval: interval})

  @doc """
  Fetches the prices for wheat

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "299.44000625"
      },
    ],
    "interval" => "monthly",
    "name" => "Global Price of Wheat",
    "unit" => "dollar per metric ton"
  }
  ```
  """
  def wheat(interval \\ "monthly"), do: get(%{function: "WHEAT", interval: interval})

  @doc """
  Fetches the prices for corn

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "268.172526360544"
      },
    ],
    "interval" => "monthly",
    "name" => "Global Price of Corn",
    "unit" => "dollar per metric ton"
  }
  ```
  """
  def corn(interval \\ "monthly"), do: get(%{function: "CORN", interval: interval})

  @doc """
  Fetches the prices for cotton

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "93.8847826086957"
      },
    ],
    "interval" => "monthly",
    "name" => "Global Price of Cotton",
    "unit" => "cents per pound"
  }
  ```
  """
  def cotton(interval \\ "monthly"), do: get(%{function: "COTTON", interval: interval})

  @doc """
  Fetches the prices for sugar

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "25.7295652173913"
      },
    ],
    "interval" => "monthly",
    "name" => "Global Price of Sugar",
    "unit" => "cents per pound"
  }
  ```
  """
  def sugar(interval \\ "monthly"), do: get(%{function: "SUGAR", interval: interval})

  @doc """
  Fetches the prices for coffee

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "220.121304347826"
      },
    ],
    "interval" => "monthly",
    "name" => "Global Price of Coffee",
    "unit" => "cents per pound"
  }
  ```
  """
  def coffee(interval \\ "monthly"), do: get(%{function: "COFFEE", interval: interval})

  @doc """
  Fetches the prices for commodities index

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "158.293349926295"
      },
    ],
    "interval" => "monthly",
    "name" => "Global Price Index of All Commodities",
    "unit" => "index 2016=100"
  }
  ```
  """
  def commodities(interval \\ "monthly"),
    do: get(%{function: "ALL_COMMODITIES", interval: interval})

  @doc """
  Fetches the real GDP of the United States.

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2022-01-01",
        "value" => "20014.128"
      },
    ],
    "interval" => "annual",
    "name" => "Real Gross Domestic Product",
    "unit" => "billions of dollars"
  }
  ```
  """
  def real_gdp(interval \\ "annual"), do: get(%{function: "REAL_GDP", interval: interval})

  @doc """
  Fetches the real GDP per capita of the United States.

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-01-01",
        "value" => "60502.0"
      },
    ],
    "interval" => "quarterly",
    "name" => "Real Gross Domestic Product per Capita",
    "unit" => "chained 2012 dollars"
  }
  ```
  """
  def real_gdp_per_capita, do: get(%{function: "REAL_GDP_PER_CAPITA"})

  @doc """
  Fetches the treasury yield of the United States.

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.
  * `maturity` - The maturity of treasury yield.

  ## Response

  ```elixir%{
    "data" => [
      %{
        "date" => "2023-06-27",
        "value" => "3.77"
      },
    ],
    "interval" => "daily",
    "name" => "10-Year Treasury Constant Maturity Rate",
    "unit" => "percent"
  }
  ```
  """
  def treasury_yield(interval \\ "daily", maturity \\ "10year"),
    do: get(%{function: "TREASURY_YIELD", interval: interval, maturity: maturity})

  @doc """
  Fetches the federal funds rate of the United States.

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "5.06"
      },
    ],
    "interval" => "monthly",
    "name" => "Effective Federal Funds Rate",
    "unit" => "percent"
  }
  ```
  """
  def federal_funds_rate(interval \\ "monthly"),
    do: get(%{function: "FEDERAL_FUNDS_RATE", interval: interval})

  @doc """
  Fetches the consumer price index of the United States.

  ## Inputs

  * `interval` - The interval between two consecutive data points in the time series.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "304.127"
      },
    ],
    "interval" => "monthly",
    "name" => "Consumer Price Index for all Urban Consumers",
    "unit" => "index 1982-1984=100"
  }
  ```
  """
  def cpi(interval \\ "monthly"), do: get(%{function: "CPI", interval: interval})

  @doc """
  Fetches the inflation rate of the United States.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2022-01-01",
        "value" => "8.00279982052117"
      },
    ],
    "interval" => "annual",
    "name" => "Inflation - US Consumer Prices",
    "unit" => "percent"
  }
  ```
  """
  def inflation, do: get(%{function: "INFLATION"})

  @doc """
  Fetches the retail sales of the United States.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "629656.0"
      },
    ],
    "interval" => "monthly",
    "name" => "Advance Retail Sales: Retail Trade",
    "unit" => "millions of dollars"
  }
  ```
  """
  def retail_sales, do: get(%{function: "RETAIL_SALES"})

  @doc """
  Fetches the durable goods orders of the United States.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "288027"
      },
    ],
    "interval" => "monthly",
    "name" => "Manufacturer New Orders: Durable Goods",
    "unit" => "millions of dollars"
  }
  ```
  """
  def durable_goods_orders, do: get(%{function: "DURABLES"})

  @doc """
  Fetches the unemployment rate of the United States.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "3.7"
      },
    ],
    "interval" => "monthly",
    "name" => "Unemployment Rate",
    "unit" => "percent"
  }
  ```
  """
  def unemployment_rate, do: get(%{function: "UNEMPLOYMENT"})

  @doc """
  Fetches the nonfarm payroll of the United States.

  ## Response

  ```elixir
  %{
    "data" => [
      %{
        "date" => "2023-05-01",
        "value" => "156306"
      },
    ],
    "interval" => "monthly",
    "name" => "Total Nonfarm Payroll",
    "unit" => "thousands of persons"
  }
  ```
  """
  def nonfarm_payroll, do: get(%{function: "NONFARM_PAYROLL"})

  @doc false
  defp get(params) do
    SimpleRateLimiter.wait_and_proceed(fn ->
      api_key = Application.get_env(:alpha_vantage_client, :api_key)
      url = "#{@base_url}?#{URI.encode_query(params)}&apikey=#{api_key}"

      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          case Jason.decode!(body) do
            %{"Error Message" => message} ->
              {:error, message}

            data ->
              {:ok, data}
          end

        {:ok, %HTTPoison.Response{status_code: code}} ->
          {:error, {:unexpected_status_code, code}}

        {:error, %HTTPoison.Error{reason: reason}} ->
          {:error, reason}
      end
    end)
  end
end
