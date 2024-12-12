import AOC

aoc_test 2024, 8, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2024, day: 8) == 299
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2024, day: 8) == 1032
  end
end
