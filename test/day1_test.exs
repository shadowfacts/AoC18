defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "calculate frequency" do
    assert Day1.calculate_frequency([1, -2, 3, 1]) == 3
    assert Day1.calculate_frequency([1, 1, 1]) == 3
    assert Day1.calculate_frequency([1, 1, -2]) == 0
    assert Day1.calculate_frequency([-1, -2, -3]) == -6
  end

  test "first repetition" do
    assert Day1.first_repetition([1, -2, 3, 1]) == 2
    assert Day1.first_repetition([1, -1]) == 0
    assert Day1.first_repetition([3, 3, 4, -2, -4]) == 10
    assert Day1.first_repetition([-6, 3, 8, 5, -6]) == 5
    assert Day1.first_repetition([7, 7, -2, -7, -4]) == 14
  end
end
