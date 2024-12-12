import AOC

aoc_test 2022, 8, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2022, day: 8) == 1803
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2022, day: 8) == 268912
  end
end
