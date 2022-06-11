# wc.ex
defmodule WC do
  @moduledoc """
   this module implements the wc from linux
  """

  @doc """
    this function get the filename from arg and compute the wc
  """
  def main do
    System.argv()
    |> hd
    |> String.trim()
    |> main()
  end

  @doc """

    # Params
    - filename: the file to read the content

    this function count the rows, words and chars from an file
  """
  def main(filename) do
    content = File.read!(filename)

    rows =
      content
      |> String.graphemes()
      |> Enum.count(&(&1 == "\n"))

    words =
      content
      |> String.split(~r{\n|\s+})
      |> Enum.filter(&(&1 != ""))
      |> Enum.count()

    chars =
      content
      |> String.length()

    IO.puts("  #{rows} #{words} #{chars} #{filename}")
  end
end

WC.main()
