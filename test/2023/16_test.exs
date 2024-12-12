import AOC

aoc_test 2023, 16, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 16) == 7210
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 16) == 7673
  end
end