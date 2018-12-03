defmodule Day3 do
  
  defmodule Rect do
    defstruct [:id, :left, :top, :width, :height]

    def points(nil), do: []
    def points(rect) do
      xs = rect.left..(rect.left + rect.width - 1)
      Enum.flat_map(xs, fn x ->
        ys = rect.top..(rect.top + rect.height - 1)
        Enum.map(ys, fn y -> {x, y} end)
      end)
    end

    def overlap(a, b) do
      overlap_left = max(a.left, b.left)
      overlap_width = max(0, min(a.left +  a.width, b.left + b.width) - overlap_left)
      overlap_top = max(a.top, b.top)
      overlap_height = max(0, min(a.top + a.height, b.top + b.height) - overlap_top)
      case overlap_width * overlap_height do
        0 ->
          nil
        _ ->
          %Rect{left: overlap_left, top: overlap_top, width: overlap_width, height: overlap_height}
      end
    end
  end

  def parse_rect(str) do
    parts = Regex.run(~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/, str)
    %Rect{
      id: parts |> Enum.at(1) |> String.to_integer,
      left: parts |> Enum.at(2) |> String.to_integer,
      top: parts |> Enum.at(3) |> String.to_integer,
      width: parts |> Enum.at(4) |> String.to_integer,
      height: parts |> Enum.at(5) |> String.to_integer,
    }
  end

  def except(list, except) do
    Enum.reject(list, fn el -> el == except end)
  end

  def overlap_area(rects) do
    rects
      |> Enum.flat_map(fn rect ->
        rects
          |> except(rect)
          |> Enum.map(fn other ->
            Rect.overlap(rect, other)
          end)
          |> Enum.flat_map(&Rect.points/1)
      end)
      |> Enum.uniq
      |> Enum.count
  end

  def exclude_overlapping(rects) do
    rects
      |> Enum.reject(fn rect ->
        rects
          |> except(rect)
          |> Enum.any?(fn other ->
            Rect.overlap(rect, other) != nil
          end)
      end)
  end

  def parse_input() do
    File.read!("lib/day3/input.txt")
      |> String.split("\n", trim: true)
  end

  def part1() do
    parse_input()
      |> Enum.map(&parse_rect/1)
      |> overlap_area()
  end

  def part2() do
    parse_input()
      |> Enum.map(&parse_rect/1)
      |> exclude_overlapping()
  end

end