import AOC

aoc_test 2023, 7, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 7) == 254024898
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 7) == 254115617
  end
end
