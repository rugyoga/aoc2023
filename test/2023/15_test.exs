import AOC

aoc_test 2023, 15, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 15) == 513158
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 15) == 200277
  end
end