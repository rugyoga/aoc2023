import AOC

aoc_test 2024, 1, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2024, day: 1) == 1882714
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2024, day: 1) == 19437052
  end
end