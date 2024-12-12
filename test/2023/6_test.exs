import AOC

aoc_test 2023, 6, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 6) == 219849
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 6) == 29432455
  end
end
