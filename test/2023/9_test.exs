import AOC

aoc_test 2023, 9, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 9) == 1798691765
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 9) == 1104
  end
end