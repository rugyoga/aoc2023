import AOC

aoc_test 2023, 17, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 17) == 1260
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 17) == 1465
  end
end
