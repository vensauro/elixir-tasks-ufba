# exemplos.ex

[low, high] = [10, 60]

# anonymous function
random_number = fn low, high -> low..high |> Enum.random() end
random_number.(low, high)

# anonymous function with ampersand shortcut
random_number = &Enum.random(&1..&2)
random_number.(low, high)

handle_http_result = fn
  {:ok, %{status_code: 200, body: body}} ->
    "Deu certo o request, agora fazemos o decode do json em Map"

  {:ok, %{status_code: 404}} ->
    "Não achou o recurso"

  {:error, %{reason: reason}} ->
    "Deu erro, e agora oq fazemos Maria José"
end

defmodule Example do
  def random(low, high) do
    low..high |> Enum.random()
  end

  def random(high), do: 0..high |> Enum.random()

  def handle_http_result({:ok, %{status_code: 200, body: body}}) do
    "Deu certo o request, agora fazemos o decode do json em Map"
  end

  def handle_http_result({:ok, %{status_code: 404}}) do
    "Não achou o recurso"
  end

  def handle_http_result({:error, %{reason: reason}}) do
    "Deu erro, e agora oq fazemos Maria José"
  end

  defp mid(low, high) when is_number(low) and is_number(high) do
    div(low + high, 2)
  end
end
