import AOC

aoc_test 2023, 11, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 11) == 9591768
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 11) == 746962097860
  end
end
