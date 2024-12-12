import AOC

aoc_test 2023, 12, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 12) == 7379
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 12) == 7732028747925
  end
end
