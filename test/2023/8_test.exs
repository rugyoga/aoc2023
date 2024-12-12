import AOC

aoc_test 2023, 8, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 8) == 19631
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 8) == 21003205388413
  end
end
