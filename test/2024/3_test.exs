import AOC

aoc_test 2024, 3, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2024, day: 3) == 164730528
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2024, day: 3) == 70478672
  end
end
