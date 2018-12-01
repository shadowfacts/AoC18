defmodule Day1 do
  def calculate_frequency(shifts) do
    shifts
      |> Enum.reduce(0, &+/2)
  end

  def first_repetition(shifts, index \\ 0, sum \\ 0, seen \\ [0]) do
    sum = sum + Enum.at(shifts, index)
    next_index = rem(index + 1, Enum.count(shifts))

    cond do
      Enum.member?(seen, sum) ->
        sum
      true ->
        first_repetition(shifts, next_index, sum, [sum | seen])
    end
  end

  def parse_input() do
    File.read!("lib/day1/input.txt")
      |> String.split("\n")
      |> Enum.map(fn s ->
        {num, _} = Integer.parse(s)
        num
      end)
  end

  def part1() do
    parse_input()
      |> calculate_frequency()
  end

  def part2() do
    parse_input()
      |> first_repetition()
  end
end