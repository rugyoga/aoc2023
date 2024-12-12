import AOC

aoc_test 2022, 11, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2022, day: 11) == 119715
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2022, day: 11) == 18085004878
  end
end
