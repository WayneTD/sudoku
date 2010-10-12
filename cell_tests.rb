require 'test/unit'
require './cell.rb'

class CellTests < Test::Unit::TestCase
  def test_new_cell_should_contain_correct_values
    c = Cell.new(1, 2, 3, 4)
    assert_equal(1, c.row)
    assert_equal(2, c.column)
    assert_equal(3, c.group)
    assert_equal(4, c.value)
    assert_equal(0, c.possible_values.length)
  end
  
  def test_neighbouring_cells_has_value
    c = Cell.new(1, 2, 3, 4)
    c.neighbouring_cells = Array.new(20).fill Cell.new(1, 1, 1, 1)
    assert_equal(true, c.neighbouring_cell_has_value(1))
  end
    
  def test_neighbouring_cells_do_not_have_value
    c = Cell.new(1, 2, 3, 4)
    c.neighbouring_cells = Array.new(20).fill Cell.new(1, 1, 1, 1)
    assert_equal(false, c.neighbouring_cell_has_value(9))
  end

  def test_cloned_cell_has_correct_values
    c = Cell.new(1, 2 ,3 ,4)
    c.possible_values = [1, 2, 3]
    c.neighbouring_cells = Array.new(20).fill Cell.new(1,2,3,4)
    clone = c.clone
    assert_equal(1, clone.row)
    assert_equal(2, clone.column)
    assert_equal(3, clone.group)
    assert_equal(4, clone.value)
    assert_equal([1, 2, 3], clone.possible_values)
    assert_equal(20, clone.neighbouring_cells.length)
  end
end
