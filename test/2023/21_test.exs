import AOC

aoc_test 2023, 21, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 21) == 3660
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 21) == 605492675373144
  end
end
