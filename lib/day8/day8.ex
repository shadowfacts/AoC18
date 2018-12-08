defmodule Day8 do
  def create_node(numbers, indent \\ "") do
    # IO.puts "#{indent}numbers: #{numbers |> Enum.join(", ")}"

    [children_count, meta_count | numbers] = numbers

    {children, numbers} =
      if children_count > 0 do
        IO.puts("#{indent}creating #{children_count} children")
        Enum.reduce(1..children_count, {[], numbers}, fn child, {children, numbers} ->
          IO.puts "#{indent}creating child #{child}"
          {child, numbers} = create_node(numbers, indent <> "  ")
          {
            [child | children],
            numbers
          }
        end)
      else
        {[], numbers}
      end

    {metadata, numbers} = 
      if meta_count > 0 do
        {
          Enum.slice(numbers, 0, meta_count),
          Enum.slice(numbers, meta_count..-1)
        }
      else
        {[], numbers}
      end

    IO.puts "#{indent}metadata: #{metadata |> Enum.join(", ")}"

    {
      {children |> Enum.reverse(), metadata},
      numbers
    }
  end

  def sum_metadata({[], metadata}), do: Enum.sum(metadata)
  def sum_metadata({children, metadata}) do
    children_sum = Enum.map(children, &sum_metadata/1) |> Enum.sum()
    children_sum + Enum.sum(metadata)
  end

  def node_value({children, metadata}) when length(children) == 0 do
    Enum.sum(metadata)
  end
  def node_value({children, metadata}) do
    # IO.inspect(children)
    metadata
    # |> IO.inspect
    |> Enum.map(fn index ->
      # IO.inspect(index - 1)
      case Enum.fetch(children, index - 1) do
        {:ok, child} -> node_value(child)
        :error -> 0
      end
    end)
    |> Enum.sum()
  end

  def parse_input() do
    File.read!("lib/day8/input.txt")
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1() do
    {node, _numbers} =
      parse_input()
      |> create_node()
    sum_metadata(node)
  end

  def part2() do
    {node, _numbers} =
      parse_input()
      |> create_node()
    node_value(node)
  end
end
