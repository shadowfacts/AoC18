defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "count characters" do
    assert Day2.count_characters("abcdef") == %{
             "a" => 1,
             "b" => 1,
             "c" => 1,
             "d" => 1,
             "e" => 1,
             "f" => 1
           }

    assert Day2.count_characters("bababc") == %{"a" => 2, "b" => 3, "c" => 1}
    assert Day2.count_characters("abbcde") == %{"a" => 1, "b" => 2, "c" => 1, "d" => 1, "e" => 1}
  end

  test "checksum list" do
    list = ["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]
    assert Day2.checksum(list) == 12
  end

  test "diff" do
    assert Day2.diff("fghij", "fguij") == {1, "fgij"}
  end

  test "match" do
    list = ["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"]
    assert Day2.match("fghij", list) == "fgij"
  end

  test "correct boxes" do
    list = ["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"]
    assert Day2.correct_boxes(list) == "fgij"
  end
end
