import AOC

aoc_test 2023, 1, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 1) == 54916
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 1) == 54728
  end
end
