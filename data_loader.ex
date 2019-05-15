defmodule DataLoader do
  @moduledoc false

  def import(filename \\ "pollution.csv") do
    File.read!(filename) |> String.split("\r\n")
  end

  def parse(line) do
    [date, time, x, y, value] = line |> String.split(",")
    {day, month, year} = date |> String.split("-") |> Enum.reverse |> Enum.map(&String.to_integer/1) |> :erlang.list_to_tuple
    {h, m} = time |> String.split(":") |> Enum.map(&String.to_integer/1) |> :erlang.list_to_tuple
    {hour, minute, second} = {h, m, 0}
    location = {String.to_float(x), String.to_float(y)}
    pollution = value |> String.to_integer
    result = %{:datetime => {{day, month, year}, {hour, minute, second}},
      :location => location,
      :pollutionLevel => pollution}
  end

  def identifyStations() do
    import |> Enum.map(&parseLocation/1) |> Enum.uniq |> length
  end

  def parseLocation(line) do
    [date, time, x, y, value] = line |> String.split(",")
    location = {String.to_float(x), String.to_float(y)}
  end

end
