import AOC

aoc_test 2022, 16, async: true do
  @tag skip: true
  test "part 1" do
    assert AOC.IEx.p1i(year: 2022, day: 16) == 1
  end

  @tag skip: true
  test "part 2" do
    assert AOC.IEx.p2i(year: 2022, day: 16) == 2
  end
end
