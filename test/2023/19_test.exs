import AOC

aoc_test 2023, 19, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2023, day: 19) == 333263
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2023, day: 19) == 130745440937650
  end
end
