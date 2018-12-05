defmodule Day5 do
  
  @doc """
  Compares two codepoints for opposite case.

  ## Examples

      iex> Day5.react('dabAcCaCBAcCcaDA')
      'dabCBAcaDA'

  """
  def react(chars) do
    chars
    |> Enum.reduce('', fn
      c, [prev | rest] = s ->
        if oppCase(c, prev) do
          rest
        else
          [c | s]
        end
      c, [] ->
        [c]
    end)
    |> Enum.reverse()
    |> case do
      ^chars -> chars
      remaining -> react(remaining)
    end
  end

  @doc """
  Compares two codepoints for opposite case.

  ## Examples

      iex> Day5.oppCase(?a, ?A)
      true
      iex> Day5.oppCase(?A, ?a)
      true
      iex> Day5.oppCase(?A, ?A)
      false
      iex> Day5.oppCase(?B, ?A)
      false

  """
  def oppCase(c1, c2) do
    s1 = <<c1::utf8>>
    s2 = <<c2::utf8>>
    lower1 = String.downcase(s1)
    upper1 = String.upcase(s1)
    lower2 = String.downcase(s2)

    cond do
      lower1 != lower2 -> false
      s1 == lower1 && s1 == s2 -> false
      s1 == upper1 && s1 == s2 -> false
      true -> true
    end
  end

  @doc """
  Compares two codepoints for opposite case.

  ## Examples

      iex> Day5.min_length("dabAcCaCBAcCcaDA")
      4

  """
  def min_length(input) do
    input
    |> String.downcase()
    |> String.to_charlist()
    |> Enum.uniq()
    |> Enum.map(fn c ->
      s = <<c::utf8>>
      str = String.replace(input, s, "")
      str = String.replace(str, String.upcase(s), "")
      input
      |> String.replace(s, "")
      |> String.replace(String.upcase(s), "")
      |> String.to_charlist()
      |> react()
    end)
    |> Enum.min_by(&length/1)
    |> length()
  end

  def parse_input() do
    File.read!("lib/day5/input.txt")    
  end

  def part1() do
    parse_input()
    |> String.to_charlist()
    |> react()
    |> length()
  end

  def part2() do
    parse_input()
    |> min_length()
  end

end