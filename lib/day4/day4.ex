defmodule Day4 do

  defmodule Timestamp do
    defstruct [:year, :month, :day, :hour, :minute]

    def create(y, m, d, h, min) do
      %Timestamp{
        year: y |> String.to_integer(),
        month: m |> String.to_integer(),
        day: d |> String.to_integer(),
        hour: h |> String.to_integer(),
        minute: min |> String.to_integer
      }
    end

    def range(first, second) do
      first.minute..second.minute
    end
  end
  
  def parse_event(line) do
    res = Regex.run(~r/\[(\d+)-(\d+)-(\d+) (\d+):(\d+)\] (.+)/, line)
    [_line, y, m, d, h, min, event | _tail] = res
    {
      Timestamp.create(y, m, d, h, min),
      event
    }
  end

  def parse_events(lines) do
    lines
    |> Enum.map(&parse_event/1)
  end

  def sort_events(events) do
    events
    |> Enum.sort_by(fn {ts, _} ->
      {ts.year, ts.month, ts.day, ts.hour, ts.minute}
    end)
  end

  def parse_guard({_, msg}) do
    case Regex.run(~r/Guard #(\d+) begins shift/, msg) do
      [_event, id | _tail] -> id
      _ -> nil
    end
  end

  def get_sleep_times(events) do
    chunk_fun = fn event, acc ->
      case parse_guard(event) do
        nil -> {:cont, [event | acc]}
        _id -> {:cont, Enum.reverse(acc), [event]}
      end
    end
    after_fun = fn
      [] -> {:cont, []}
      acc -> {:cont, Enum.reverse(acc), acc}
    end
    events
    |> Enum.chunk_while([], chunk_fun, after_fun)
    |> Enum.reject(fn
      [] -> true
      _ -> false
    end)
    |> Enum.reduce(%{}, fn [begin_shift | events], acc ->
      guard_id = parse_guard(begin_shift)
      ranges = events
      |> Enum.chunk_every(2)
      |> Enum.map(fn [{sleep, _}, {wake, _} | []] ->
        Timestamp.range(sleep, wake)
      end)
      Map.update(acc, guard_id, ranges, &(&1 ++ ranges))
    end)
    |> Enum.reject(fn
      {_id, []} -> true
      _ -> false
    end)
  end

  def get_max_sleep_time(guards) do
    guards
    |> Enum.map(fn {id, times} ->
      total = times
      |> Enum.map(fn a..b -> b - a end)
      |> Enum.sum()
      {minute, _count} = times
      |> Enum.flat_map(&Enum.to_list/1)
      |> Enum.reduce(%{}, fn minute, acc ->
        Map.update(acc, minute, 1, &(&1 + 1))
      end)
      |> Enum.max_by(fn {_minute, count} -> count end)
      {id, total, minute}
    end)
    |> Enum.max_by(fn {_id, total, _minute} -> total end)
  end

  def range_containing(ranges) do
    first = Enum.reduce(ranges, Enum.at(ranges, 0).first, fn first.._, acc ->
      min(first, acc)
    end)
    last = Enum.reduce(ranges, Enum.at(ranges, 0).last, fn _..last, acc ->
      max(last, acc)
    end)
    first..last
  end

  def get_most_frequent_sleep_time(guards) do
    guards
    |> Enum.map(fn {id, times} ->
      {minute, count} = range_containing(times)
      |> Enum.map(fn minute ->
        {minute, Enum.count(times, fn range -> minute in range end)}
      end)
      |> Enum.max_by(fn {_minute, count} -> count end)
      {id, minute, count}
    end)
    |> Enum.max_by(fn {_id, _minute, count} -> count end)
  end

  def parse_input() do
    File.read!("lib/day4/input.txt")
    |> String.split("\n", trim: true)
  end

  def part1() do
    {id, _total, minute} = parse_input()
    |> parse_events()
    |> sort_events()
    |> get_sleep_times()
    |> get_max_sleep_time()
    String.to_integer(id) * minute
  end

  def part2() do
    {id, minute, _count} = parse_input()
    |> parse_events()
    |> sort_events()
    |> get_sleep_times()
    |> get_most_frequent_sleep_time()
    String.to_integer(id) * minute
  end

end