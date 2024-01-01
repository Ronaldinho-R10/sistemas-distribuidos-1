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
    3. Deletar ponto
    4. Sair
    """)

    IO.write("Escolha uma opção: ")
    choice = String.trim(IO.gets(""))

    case choice do
      "1" -> add_point_menu(points)
      "2" -> list_points_menu(points)
      "3" -> delete_point_menu(points)
      "4" -> IO.puts("Saindo. Adeus!")
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