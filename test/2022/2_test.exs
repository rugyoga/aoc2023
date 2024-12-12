import AOC

aoc_test 2022, 2, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2022, day: 2) == 11449
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2022, day: 2) == 13187
  end
end
