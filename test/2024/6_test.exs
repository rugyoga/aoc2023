import AOC

aoc_test 2024, 6, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2024, day: 6) == 4647
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2024, day: 6) == 1723
  end
end
