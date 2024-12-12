import AOC

aoc_test 2023, 5, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 5) == 51580674
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 5) == 99751240
  end
end
