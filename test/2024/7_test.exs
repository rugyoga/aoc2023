import AOC

aoc_test 2024, 7, async: true do
  test "part 1" do
    assert AOC.IEx.p1i(year: 2024, day: 7) == 2314935962622
  end

  test "part 2" do
    assert AOC.IEx.p2i(year: 2024, day: 7) == 401477450831495
  end
end
