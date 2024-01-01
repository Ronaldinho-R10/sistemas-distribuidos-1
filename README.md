# Atividade Final de Sistemas Distribuidos

## Faça um sistema que envolva 4 funções que pode ser executadas usando tarefas. Você pode aproveitar o sistema CRUD feito na tarefa anterior.

### Para exeutar o script use o comando
```bash
cd atividade

iex -S mix

AsyncCrudSystem.start_link #Inicia o GenServer

AsyncCrudSystem.create_async(%{campo1: "valor1", campo2: "valor2"}) # Task de criar

AsyncCrudSystem.read_async(1) # Task de Ler com Execeção não tratada, mas funciona

AsyncCrudSystem.update_async(1, %{campo1: "novo_valor"}) # Task de Atualização

AsyncCrudSystem.delete_async(1) # Task de Deletar
```

```elixir
defmodule AsyncCrudSystem do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def create_async(params) do
    GenServer.cast(__MODULE__, {:create, params})
  end

  def read_async(id) do
    GenServer.call(__MODULE__, {:read, id})
  end

  def update_async(id, params) do
    GenServer.cast(__MODULE__, {:update, id, params})
  end

  def delete_async(id) do
    GenServer.cast(__MODULE__, {:delete, id})
  end

  # Funções do GenServer

  def init(_) do
    {:ok, %{}}
  end

  def handle_cast({:create, params}, state) do
    Task.start_link(fn ->
      create_record(params)
    end)
    {:noreply, state}
  end

  def handle_call({:read, id}, _from, state) do
    result =
      Task.await(
        Task.start_link(fn ->
          read_record(id)
        end)
      )
    {:reply, result, state}
  end

  def handle_cast({:update, id, params}, state) do
    Task.start_link(fn ->
      update_record(id, params)
    end)
    {:noreply, state}
  end

  def handle_cast({:delete, id}, state) do
    Task.start_link(fn ->
      delete_record(id)
    end)
    {:noreply, state}
  end

  # Funções privadas

  defp create_record(params) do
    # Simula a lógica de criação do registro
    IO.puts("Criando registro: #{inspect(params)}")
  end

  defp read_record(id) do
    # Simula a lógica de leitura do registro
    IO.puts("Lendo registro com ID #{id}")
    %{id: id, dados: "Exemplo de dados"}
  end

  defp update_record(id, params) do
    # Simula a lógica de atualização do registro
    IO.puts("Atualizando registro com ID #{id} - Novos dados: #{inspect(params)}")
  end

  defp delete_record(id) do
    # Simula a lógica de exclusão do registro
    IO.puts("Excluindo registro com ID #{id}")
  end
end
```

## Faça um sistema CRUD em Elixir para cadastrar os pontos de um polígono (Ou outra aplicação qualquer). A entrega deverá ser presencial.

### Para exeutar o script use o comando

```bash
elixir poligono.ex
```


```elixir
defmodule PolygonManager do
  @polygons %{}

  # Create
  def add_point(polygons, {x, y}) do
    updated_polygons = [{x, y} | polygons]
    {:ok, updated_polygons}
  end

  # Read
  def list_points(polygons) do
    if Enum.empty?(polygons) do
      {:error, "Nenhum ponto encontrado."}
    else
      {:ok, polygons}
    end
  end

  # Update
  def update_point(polygons, old_point, new_point) do
    updated_polygons = Enum.map(polygons, fn
      ^old_point -> new_point
      point -> point
    end)
    {:ok, updated_polygons}
  end

  # Delete
  def delete_point(polygons, point) do
    updated_polygons = Enum.filter(polygons, &(&1 != point))
    {:ok, updated_polygons}
  end
end

defmodule Menu do
  def start_menu do
    points = []
    menu(points)
  end

  def menu(points) do
    IO.puts("""
    Menu:
    1. Adicionar ponto
    2. Listar pontos
    3. Atualizar ponto
    4. Deletar ponto
    5. Sair
    """)

    IO.write("Escolha uma opção: ")
    choice = String.trim(IO.gets(""))

    case choice do
      "1" -> add_point_menu(points)
      "2" -> list_points_menu(points)
      "3" -> edit_point_menu(points)
      "4" -> delete_point_menu(points)
      "5" -> IO.puts("Saindo. Adeus!")
      _ -> IO.puts("Opção inválida. Tente novamente.")
    end
  end

  def add_point_menu(points) do
    IO.write("Coordenada x: ")
    x = String.trim(IO.gets(""))

    IO.write("Coordenada y: ")
    y = String.trim(IO.gets(""))

    { :ok, updated_points } = PolygonManager.add_point(points, {String.to_integer(x), String.to_integer(y)})
    IO.inspect updated_points

    menu(updated_points)
  end

  def list_points_menu(points) do
    case PolygonManager.list_points(points) do
      {:ok, listed_points} ->
        if Enum.empty?(listed_points) do
          IO.puts("Nenhum ponto encontrado.")
        else
          IO.puts("Pontos:")
          IO.inspect listed_points
        end
        menu(points)

      {:error, msg} ->
        IO.puts("Erro ao listar pontos: #{msg}")
        menu(points)
    end
  end

  def edit_point_menu(points) do
    IO.write("Coordenada x do ponto a ser editado: ")
    x = String.trim(IO.gets(""))

    IO.write("Coordenada y do ponto a ser editado: ")
    y = String.trim(IO.gets(""))

    IO.write("Nova coordenada x: ")
    new_x = String.trim(IO.gets(""))

    IO.write("Nova coordenada y: ")
    new_y = String.trim(IO.gets(""))

    old_point = {String.to_integer(x), String.to_integer(y)}
    new_point = {String.to_integer(new_x), String.to_integer(new_y)}

    { :ok, updated_points } = PolygonManager.update_point(points, old_point, new_point)
    IO.inspect updated_points

    menu(updated_points)
  end

  def delete_point_menu(points) do
    IO.write("Coordenada x do ponto a ser deletado: ")
    x = String.trim(IO.gets(""))

    IO.write("Coordenada y do ponto a ser deletado: ")
    y = String.trim(IO.gets(""))

    { :ok, updated_points } = PolygonManager.delete_point(points, {String.to_integer(x), String.to_integer(y)})
    IO.inspect updated_points

    menu(updated_points)
  end
end

# Iniciar o menu
Menu.start_menu()
```



