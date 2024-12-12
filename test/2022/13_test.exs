import AOC

aoc_test 2022, 13, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2022, day: 13) == 6101
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2022, day: 13) == 21909
  end
end
