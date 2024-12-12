import AOC

aoc_test 2024, 4, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2024, day: 4) == 2718
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2024, day: 4) == 2046
  end
end
