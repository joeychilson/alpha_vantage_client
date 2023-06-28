defmodule AlphaVantage do
  @base_url "https://www.alphavantage.co/query"

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

  @doc false
  defp get(params) do
    api_key = Application.get_env(:alpha_vantage_client, :api_key)
    if api_key == nil, do: {:error, :api_key_not_set}

    url = "#{@base_url}?#{URI.encode_query(params)}&apikey=#{api_key}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode!(body) do
          {:ok, %{"Error Message" => message}} ->
            {:error, message}

          json ->
            {:ok, json}
        end

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, {:unexpected_status_code, code}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
