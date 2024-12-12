import AOC

aoc_test 2023, 25, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 25) == 568214
  end
end
