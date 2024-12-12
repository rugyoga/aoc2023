import AOC

aoc_test 2022, 7, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2022, day: 7) == 1447046
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2022, day: 7) == 578710
  end
end
