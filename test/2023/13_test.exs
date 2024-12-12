import AOC

aoc_test 2023, 13, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 13) == 26957
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 13) == 42695
  end
end
