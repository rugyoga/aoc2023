import AOC

aoc_test 2023, 18, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 18) == 186462
  end

  @tag timeout: :infinity
  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 18) == 624105292491785261
  end
end
