defmodule Day3Test do
  use ExUnit.Case
  doctest Day3
  alias Day3.Rect

  test "rect overlap" do
    a = %Rect{id: 1, left: 1, top: 3, width: 4, height: 4}
    b = %Rect{id: 2, left: 3, top: 1, width: 4, height: 4}
    assert Rect.overlap(a, b) == %Rect{id: nil, left: 3, top: 3, width: 2, height: 2}

    a = %Rect{id: 1, left: 0, top: 0, width: 4, height: 4}
    b = %Rect{id: 2, left: 4, top: 2, width: 4, height: 4}
    assert Rect.overlap(a, b) == nil
  end

  test "parse rectangle from string" do
    assert Day3.parse_rect("#1 @ 1,3: 4x4") == %Rect{id: 1, left: 1, top: 3, width: 4, height: 4}
    assert Day3.parse_rect("#2 @ 3,1: 4x4") == %Rect{id: 2, left: 3, top: 1, width: 4, height: 4}
    assert Day3.parse_rect("#3 @ 5,5: 2x2") == %Rect{id: 3, left: 5, top: 5, width: 2, height: 2}
  end

  test "overlap area" do
    rects = [
      %Rect{id: 1, left: 1, top: 3, width: 4, height: 4},
      %Rect{id: 2, left: 3, top: 1, width: 4, height: 4},
      %Rect{id: 3, left: 5, top: 5, width: 2, height: 2}
    ]
    assert Day3.overlap_area(rects) == 4
  end

  test "exclude overlapping" do
    rects = [
      %Rect{id: 1, left: 1, top: 3, width: 4, height: 4},
      %Rect{id: 2, left: 3, top: 1, width: 4, height: 4},
      %Rect{id: 3, left: 5, top: 5, width: 2, height: 2}
    ]
    res = Day3.exclude_overlapping(rects)
    assert Enum.count(res) == 1
    assert Enum.at(res, 0).id == 3
  end
  
end