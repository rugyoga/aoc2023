import AOC

aoc_test 2023, 24, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 24) == 13149
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 24) == 1033770143419859
  end
end
