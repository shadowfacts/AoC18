defmodule Day2 do
  def count_characters(id) do
    id
    |> String.graphemes()
    |> Enum.reduce(%{}, fn c, acc ->
      Map.update(acc, c, 1, &(&1 + 1))
    end)
  end

  def checksum(list) do
    characters = Enum.map(list, &count_characters/1)
    two = Enum.count(characters, any_char_count(2))
    three = Enum.count(characters, any_char_count(3))
    two * three
  end

  defp any_char_count(n) do
    fn map ->
      map
      |> Enum.to_list()
      |> Enum.any?(fn {_c, count} -> count == n end)
    end
  end

  def diff(a, b) do
    a = String.graphemes(a)
    b = String.graphemes(b)

    Enum.zip(a, b)
    |> Enum.reduce({0, ""}, fn {a, b}, {diff_count, common} ->
      cond do
        a == b ->
          {diff_count, common <> a}

        true ->
          {diff_count + 1, common}
      end
    end)
  end

  def match(id, list) do
    Enum.reduce_while(list, nil, fn other_id, _acc ->
      case diff(id, other_id) do
        {1, common} -> {:halt, common}
        _ -> {:cont, nil}
      end
    end)
  end

  def correct_boxes(list) do
    list
    |> Enum.reduce_while(nil, fn id, _acc ->
      case match(id, list) do
        nil -> {:cont, nil}
        common -> {:halt, common}
      end
    end)
  end

  def except(list, except) do
    Enum.reject(list, fn el -> el == except end)
  end

  defp parse_input() do
    File.read!("lib/day2/input.txt")
    |> String.split("\n")
  end

  def part1() do
    parse_input()
    |> checksum()
  end

  def part2() do
    parse_input()
    |> correct_boxes()
  end
end
