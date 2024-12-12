import AOC

aoc_test 2022, 3, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2022, day: 3) == 7597
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2022, day: 3) == 2607
  end
end
