import AOC

aoc_test 2024, 9, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2024, day: 9) == 6432869891895
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2024, day: 9) == 6467290479134
  end
end
