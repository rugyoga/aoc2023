import AOC

aoc_test 2023, 14, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 14) == 105208
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 14) == 102943
  end
end
