import AOC

aoc_test 2023, 20, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 20) == 711650489
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 20) == 219388737656593
  end
end
