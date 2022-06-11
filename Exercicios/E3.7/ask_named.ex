# ask_name.ex
defmodule AskName do
  @moduledoc """
    Provides functions to greet a people with their name
  """

  def ask(), do: IO.gets("What's your name? ") |> String.trim()

  def answer("your name") do
    IO.gets("Please, tell me your name: ") |> String.trim() |> answer()
  end

  def answer(name) when is_binary(name), do: "Hello #{name}, how are you?"

  def greet(), do: ask() |> answer()
end

IO.puts(AskName.greet())
