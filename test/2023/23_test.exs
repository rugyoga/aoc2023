import AOC

aoc_test 2023, 23, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 23) == 2222
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 23) == 6590
  end
end
