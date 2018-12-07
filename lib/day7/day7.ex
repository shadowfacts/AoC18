defmodule Day7 do
  
  def get_requirement(str) do
    [_, requirement, step] = Regex.run(~r/Step (\w) must be finished before step (\w) can begin./, str)
    {step, requirement}
  end

  def all_nodes(requirements) do
    requirements
    |> Enum.reduce([], fn {step, req}, acc ->
      [step | [req | acc]]
    end)
    |> Enum.uniq
  end

  def create_graph(requirements) do
    Enum.reduce(requirements, %{}, fn {step, req}, acc ->
      Map.update(acc, step, [req], &([req | &1]))
    end)
  end

  @doc """
  Topological sort implemented using Kahn's algorithm: https://en.wikipedia.org/wiki/Topological_sorting#Kahn's_algorithm
  """
  def kahn(_nodes, sorted, _graph, []), do: Enum.reverse(sorted)
  def kahn(nodes, sorted, graph, no_incoming_edges) do
    # sort no_incoming_edges lexicographically as per AoC problem
    [n | rest_no_incoming_edges] = no_incoming_edges |> Enum.sort()
    sorted = [n | sorted]
    {graph, no_incoming_edges} =
      nodes
      |> Enum.filter(fn m -> n in Map.get(graph, m, []) end)
      |> Enum.reduce({graph, rest_no_incoming_edges}, fn m, {graph, no_incoming_edges} ->
        new_dependencies_of_m = graph |> Map.get(m) |> List.delete(n)
        new_graph = graph |> Map.put(m, new_dependencies_of_m)
        {
          new_graph,
          case new_dependencies_of_m do
            [] -> [m | no_incoming_edges]
            _ -> no_incoming_edges
          end
        }
      end)
    kahn(nodes, sorted, graph, no_incoming_edges)
  end

  def kahn(nodes, graph) do
    no_incoming_edges = Enum.filter(nodes, fn node -> !Map.has_key?(graph, node) end)
    kahn(nodes, [], graph, no_incoming_edges)
  end

  def step_time(nil), do: 0
  def step_time(<<c::utf8, _rest::binary>>) do
    # step - ?A + 1 + extra
    c - ?A + 60
  end

  def tick(workers, nodes, graph, done \\ [], time \\ 0) do
    {workers, {done, nodes}} =
      Enum.map_reduce(workers, {done, nodes}, fn {current_step, remaining}, {done, nodes} ->
        case remaining do
          0 ->
            new_done = case current_step do
              nil -> done
              _ -> [current_step | done]
            end
            next_step =
              nodes
              |> Enum.find(fn node ->
                Enum.all?(Map.get(graph, node, []), fn dep -> dep in new_done end)
              end)
            new_nodes = List.delete(nodes, next_step)
            {{next_step, step_time(next_step)}, {new_done, new_nodes}}

          n when n > 0 ->
            {{current_step, n - 1}, {done, nodes}}
        end
      end)

    IO.inspect(nodes)
    IO.inspect(done)
    IO.inspect(workers)

    if length(nodes) == 0 and Enum.all?(workers, fn {step, _} -> step == nil end) do
      time - 1
    else
      tick(workers, nodes, graph, done, time + 1)
    end
  end

  def parse_input() do
    File.read!("lib/day7/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&get_requirement/1)
  end

  def part1() do
    requirements = parse_input()
    nodes = all_nodes(requirements)
    graph = create_graph(requirements)
    kahn(nodes, graph)
    |> Enum.join()
  end

  def part2() do
    requirements = parse_input()
    nodes = all_nodes(requirements)
    graph = create_graph(requirements)
    workers = for _ <- 1..5, do: {nil, 1}
    tick(workers, nodes, graph)
  end

end