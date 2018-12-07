defmodule Day4Test do
  use ExUnit.Case
  doctest Day4
  alias Day4.Timestamp

  test "parse event" do
    assert Day4.parse_event("[1518-11-01 00:00] Guard #10 begins shift") ==
             {%Timestamp{year: 1518, month: 11, day: 01, hour: 0, minute: 0},
              "Guard #10 begins shift"}
  end

  test "parse guard" do
    event =
      {%Timestamp{year: 1518, month: 11, day: 01, hour: 00, minute: 00}, "Guard #10 begins shift"}

    assert Day4.parse_guard(event) == "10"
  end

  test "sort events" do
    events = [
      {%Timestamp{year: 1518, month: 11, day: 01, hour: 00, minute: 05}, "falls asleep"},
      {%Timestamp{year: 1518, month: 11, day: 01, hour: 00, minute: 55}, "wakes up"},
      {%Timestamp{year: 1518, month: 11, day: 01, hour: 00, minute: 25}, "wakes up"},
      {%Timestamp{year: 1518, month: 11, day: 01, hour: 00, minute: 00},
       "Guard #10 begins shift"},
      {%Timestamp{year: 1518, month: 11, day: 01, hour: 00, minute: 30}, "falls asleep"}
    ]

    assert Day4.sort_events(events) == [
             {%Timestamp{year: 1518, month: 11, day: 01, hour: 00, minute: 00},
              "Guard #10 begins shift"},
             {%Timestamp{year: 1518, month: 11, day: 01, hour: 00, minute: 05}, "falls asleep"},
             {%Timestamp{year: 1518, month: 11, day: 01, hour: 00, minute: 25}, "wakes up"},
             {%Timestamp{year: 1518, month: 11, day: 01, hour: 00, minute: 30}, "falls asleep"},
             {%Timestamp{year: 1518, month: 11, day: 01, hour: 00, minute: 55}, "wakes up"}
           ]
  end

  test "get sleep times" do
    events = [
      {%Timestamp{year: 1518, month: 11, day: 1, hour: 0, minute: 0}, "Guard #10 begins shift"},
      {%Timestamp{year: 1518, month: 11, day: 1, hour: 0, minute: 5}, "falls asleep"},
      {%Timestamp{year: 1518, month: 11, day: 1, hour: 0, minute: 25}, "wakes up"},
      {%Timestamp{year: 1518, month: 11, day: 1, hour: 0, minute: 30}, "falls asleep"},
      {%Timestamp{year: 1518, month: 11, day: 1, hour: 0, minute: 55}, "wakes up"},
      {%Timestamp{year: 1518, month: 11, day: 1, hour: 23, minute: 58}, "Guard #99 begins shift"},
      {%Timestamp{year: 1518, month: 11, day: 2, hour: 0, minute: 40}, "falls asleep"},
      {%Timestamp{year: 1518, month: 11, day: 2, hour: 0, minute: 50}, "wakes up"},
      {%Timestamp{year: 1518, month: 11, day: 3, hour: 0, minute: 5}, "Guard #10 begins shift"},
      {%Timestamp{year: 1518, month: 11, day: 3, hour: 0, minute: 24}, "falls asleep"},
      {%Timestamp{year: 1518, month: 11, day: 3, hour: 0, minute: 29}, "wakes up"},
      {%Timestamp{year: 1518, month: 11, day: 4, hour: 0, minute: 2}, "Guard #99 begins shift"},
      {%Timestamp{year: 1518, month: 11, day: 4, hour: 0, minute: 36}, "falls asleep"},
      {%Timestamp{year: 1518, month: 11, day: 4, hour: 0, minute: 46}, "wakes up"},
      {%Timestamp{year: 1518, month: 11, day: 5, hour: 0, minute: 3}, "Guard #99 begins shift"},
      {%Timestamp{year: 1518, month: 11, day: 5, hour: 0, minute: 45}, "falls asleep"},
      {%Timestamp{year: 1518, month: 11, day: 5, hour: 0, minute: 55}, "wakes up"}
    ]

    assert Day4.get_sleep_times(events) == [
             {"10", [5..25, 30..55, 24..29]},
             {"99", [40..50, 36..46, 45..55]}
           ]
  end

  test "get max sleep time" do
    guards = [
      {"10", [5..25, 30..55, 24..29]},
      {"99", [40..50, 36..46, 45..55]}
    ]

    assert Day4.get_max_sleep_time(guards) == {"10", 50, 24}
  end

  test "range containing" do
    assert Day4.range_containing([5..25, 30..55, 24..29]) == 5..55
    assert Day4.range_containing([40..50, 36..46, 45..55]) == 36..55
  end

  test "most frequent sleep time" do
    guards = [
      {"10", [5..25, 30..55, 24..29]},
      {"99", [40..50, 36..46, 45..55]}
    ]

    assert Day4.get_most_frequent_sleep_time(guards) == {"99", 45, 3}
  end
end
