import AOC

aoc_test 2022, 15, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2022, day: 15) == 4919281
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2022, day: 15) == 12630143363767
  end
end
