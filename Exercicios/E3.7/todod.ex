# todo.ex
defmodule Todo do
  @moduledoc """
  This module contains a todo application that read and saves todos in a csv
  """

  @doc """
  initialize the application, creating a new todos, or reading from an existent file
  """
  def start() do
    input =
      IO.gets("Deseja criar um novo arquivo? (s/n)\n")
      |> String.trim()
      |> String.downcase()

    if input == "s" do
      create_initial_todo() |> get_command()
    else
      load_csv()
    end
  end

  @doc """
  read a file and catches the error
  """
  def read(filename) do
    case File.read(filename) do
      {:ok, body} ->
        body

      {:error, reason} ->
        IO.puts(~s/Não achei o arquivo "#{filename}"/)
        IO.puts(~s/"#{:file.format_error(reason)}"\n/)
        start()
    end
  end

  @doc """
  parses the file to a map
  """
  def parse(body) do
    [header | lines] = String.split(body, ~r/(\r\n|\r|\n)/)
    titles = tl(String.split(header, ","))
    parse_lines(lines, titles)
  end

  @doc """
  parses the lines from the file to the map
  """
  def parse_lines(lines, titles) do
    Enum.reduce(lines, %{}, fn line, built ->
      [name | fields] = String.split(line, ",")

      if Enum.count(fields) == Enum.count(titles) do
        line_data = Enum.zip(titles, fields) |> Enum.into(%{})
        Map.merge(built, %{name => line_data})
      else
        built
      end
    end)
  end

  @doc """
  loads the cvs file into the memory with a Map and starts the application
  """
  def load_csv() do
    filename = IO.gets("Nome do arquivo para carregar: ") |> String.trim()

    read(filename)
    |> parse()
    |> get_command()
  end

  @doc """
  parses the Map that the program uses to an csv string
  """
  def prepare_csv(data) do
    headers = ["Items" | get_fields(data)]
    items = Map.keys(data)
    item_rows = Enum.map(items, fn item -> [item | Map.values(data[item])] end)
    rows = [headers | item_rows]
    row_strings = Enum.map(rows, &Enum.join(&1, ","))
    Enum.join(row_strings, "\n")
  end

  @doc """
  saves the data from the application on a file
  """
  def save_csv(data) do
    file_name = IO.gets("Qual o nome do arquivo para salvar?\n") |> String.trim()
    file_data = prepare_csv(data)

    case File.write(file_name, file_data) do
      :ok ->
        IO.puts("Arquivo salvo")

      {:error, reason} ->
        IO.puts(~s/Não pude salvar o arquivo "#{file_name}"/)
        IO.puts(~s/"#{:file.format_error(reason)}\n"/)
    end

    get_command(data)
  end

  @doc """
  menu that choose the interaction
  """
  def get_command(data) do
    prompt = """
    Digite letra do comando que deseja realizar
    (L) ler atividades
    (A) adicionar atividades
    (D) apagar atividades
    (C) carregar arquivo
    (S) salvar arquivo
    (Q) fechar
    """

    command =
      IO.gets(prompt)
      |> String.trim()
      |> String.downcase()

    case command do
      "l" -> show_todos(data)
      "a" -> add_todo(data)
      "d" -> delete_todo(data)
      "c" -> load_csv()
      "s" -> save_csv(data)
      "q" -> IO.puts("Tchau baby!")
      _ -> get_command(data)
    end
  end

  @doc """
  show the todos from the application
  """
  def show_todos(data, next_command? \\ true) do
    items = Map.keys(data)
    IO.puts("Você tem as seguintes atividades:\n")
    Enum.each(items, &IO.puts/1)
    IO.write("\n")

    if next_command? do
      get_command(data)
    end
  end

  @doc """
  get just the fields from the program
  """
  def get_fields(data) do
    key = data |> Map.keys() |> hd()
    data[key] |> Map.keys()
  end

  def field_from_user(name) do
    field = IO.gets("#{name}: ") |> String.trim()

    case field do
      _ -> {name, field}
    end
  end

  @doc """
  get an todo if exists
  """
  def get_item_name(data) do
    name = IO.gets("Qual o nome da nova atividade?\n> ") |> String.trim()

    if Map.has_key?(data, name) do
      IO.puts("Já existe atividade com esse nome!\n")
      get_item_name(data)
    else
      name
    end
  end

  @doc """
  add an todo to the application
  """
  def add_todo(data) do
    name = get_item_name(data)
    titles = get_fields(data)
    fields = Enum.map(titles, &field_from_user/1)
    new_todo = %{name => Enum.into(fields, %{})}
    IO.puts(~s/Nova atividade "#{name}" adicionada/)
    new_data = Map.merge(data, new_todo)
    get_command(new_data)
  end

  def create_header(headers) do
    field_name = IO.gets("Adicione o campo: ") |> String.trim()

    case field_name do
      "" -> headers
      header -> create_header([header | headers])
    end
  end

  def create_headers() do
    IO.puts("Que informação as atividades devem ter?")
    IO.puts("Coloque o nome dos campos 1 por 1, e uma linha vazia quando acabar")
    create_header([])
  end

  def create_initial_todo do
    titles = create_headers()
    name = get_item_name(%{})
    fields = Enum.map(titles, &field_from_user/1)
    IO.puts(~s/Nova atividade #{name} adicionada./)
    %{name => Enum.into(fields, %{})}
  end

  @doc """
  removes an todo from the program
  """
  def delete_todo(data) do
    todo = IO.gets("Qual atividade você quer deletar?") |> String.trim()

    if Map.has_key?(data, todo) do
      IO.puts("Deletando...")
      new_map = Map.drop(data, [todo])
      IO.puts(~s{"#{todo}" foi deletada.})
      get_command(new_map)
    else
      IO.puts(~s{Não tem atividade com o nome "#{todo}"})
      show_todos(data, false)
      delete_todo(data)
    end
  end
end

Todo.start()
