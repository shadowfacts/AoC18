defmodule Day6 do
  @doc """
  Parses a node from a string.

  ## Examples

      iex> Day6.parse_node("1, 6")
      {1, 6}

  """
  def parse_node(s) do
    [x, y] = String.split(s, ", ")

    {
      x |> String.to_integer(),
      y |> String.to_integer()
    }
  end

  @doc """
  Distance between two coordinates.

  ## Examples

      iex> Day6.distance({0, 0}, {3, 7})
      10
  """
  def distance({x1, y1}, {x2, y2}) do
    abs(x2 - x1) + abs(y2 - y1)
  end

  @doc """

  ## Examples

      iex> Day6.nearest_node({0, 0}, [{-1, -1}, {1, 2}, {0, 1}, {3, 4}])
      {0, 1}
      iex> Day6.nearest_node({0, 0}, [{0, -1}, {1, 0}])
      nil
  """
  def nearest_node(point, all) do
    nearest =
      all
      |> Enum.map(fn other -> {other, distance(point, other)} end)

    {min_pt, min_dist} = nearest |> Enum.min_by(fn {_pt, dist} -> dist end)

    case Enum.count(nearest, fn {_pt, dist} -> dist == min_dist end) do
      1 -> min_pt
      _ -> nil
    end
  end

  def largest_region(nodes, grid_size \\ 1000) do
    {areas, infinite_area_nodes} =
      0..grid_size
      |> Enum.reduce({%{}, []}, fn y, acc ->
        0..grid_size
        |> Enum.reduce(acc, fn x, {areas, infinite_area_nodes} ->
          pt = {x, y}

          case nearest_node(pt, nodes) do
            nil ->
              {areas, infinite_area_nodes}

            nearest ->
              if x == 0 or y == 0 or x == grid_size or y == grid_size do
                {
                  areas,
                  [nearest | infinite_area_nodes]
                }
              else
                {
                  Map.update(areas, nearest, 1, &(&1 + 1)),
                  infinite_area_nodes
                }
              end
          end
        end)
      end)

    areas
    |> Enum.reject(fn {node, _area} -> node in infinite_area_nodes end)
    |> Enum.max_by(fn {_node, area} -> area end)
  end

  @doc """
  Sums the distance between the point and each of the nodes.

  ## Examples

      iex> Day6.total_distances({0, 0}, [{0, 2}, {-2, 0}, {3, 5}])
      12
  """
  def total_distances(pt, nodes) do
    nodes
    |> Enum.map(fn node -> distance(pt, node) end)
    |> Enum.sum()
  end

  def region_near_most(nodes, grid_size \\ 1000, max_dist \\ 10000) do
    0..grid_size
    |> Enum.reduce([], fn y, acc ->
      0..grid_size
      |> Enum.reduce(acc, fn x, acc ->
        pt = {x, y}

        cond do
          total_distances(pt, nodes) < max_dist ->
            [pt | acc]

          true ->
            acc
        end
      end)
    end)
  end

  def parse_input() do
    File.read!("lib/day6/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_node/1)
  end

  def part1() do
    parse_input()
    |> largest_region()
  end

  def part2() do
    parse_input()
    |> region_near_most()
    |> Enum.count()
  end
end
