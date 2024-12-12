import AOC

aoc_test 2023, 3, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 3) == 539713
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 3) == 84159075
  end
end
