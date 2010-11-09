require 'test/unit'
on_windows = ENV['windir'] != nil
require on_windows ? '.\grid.rb' : './grid.rb'  
  
class GridTests < Test::Unit::TestCase
  EMPTY_SUDOKU = 
    '000|000|000' +
    '000|000|000' +
    '000|000|000' +
    '---+---+---' +
    '000|000|000' +
    '000|000|000' +
    '000|000|000' +
    '---+---+---' +
    '000|000|000' +
    '000|000|000' +
    '000|000|000'
        
  DIFFICULT_SUDOKU = 
    '510|060|000' +
    '008|000|000' +
    '060|010|702' +
    '---+---+---' +
    '900|074|001' +
    '003|608|070' +
    '000|000|450' +
    '---+---+---' +
    '000|000|940' +
    '090|000|000' +
    '300|240|000'

  EASY_SUDOKU = 
    '050306007000085024098420603901003206030000010507260908405090380010570002800104070'      
  
  SUPER_DIFFICULT_SUDOKU = 
    '000000000000390280040021093600070900900502006005060001180250030064018000000000000'
               
  UNSOLVABLE_SUDOKU = 
    '059306007000085024098420603901003206030000010507260908405090380010570002800104070' #Same as DIFFICULT_SUDOKU with rogue 9 value in third cell

  def test_new_grid_initialized_with_more_than_1_arg_should_raise
    begin
      g = Grid.new(1, 2)
    rescue Exception => e
    end
    assert_equal(ArgumentError, e.class)
  end

  def test_new_grid_initialized_with_no_args_should_be_empty
    g = Grid.new()
    assert_equal(EMPTY_SUDOKU, g.to_s)
  end

  def test_new_grid_initialised_with_invalid_arg_should_raise
    begin
      g = Grid.new('1234')
    rescue Exception => e
    end
    assert_equal(ArgumentError, e.class)
  end

  def test_new_grid_initialized_with_valid_text_should_be_initialized_correctly
    g = Grid.new(DIFFICULT_SUDOKU)
    assert_equal(DIFFICULT_SUDOKU, g.to_s)
  end

  def test_cell_at_row_9_column_1_should_have_group_7
    g = Grid.new()
    assert_equal(7, g.get_cell_by_row_and_column(9, 1).group)
  end

  def test_cell_at_row_1_column_3_should_have_correct_possible_values
    g = Grid.new(DIFFICULT_SUDOKU)
    g.derive_possible_values
    assert_equal([2, 4, 7, 9], g.get_cell_by_row_and_column(1, 3).possible_values)
  end
  
  def test_easy_grid_is_solvable
    g = Grid.new(EASY_SUDOKU)
    start_time = Time.now
    solvable = g.is_solvable
    puts "Easy sudoku solved in #{Time.now - start_time} sec"
    assert_equal(true, solvable)
  end

  def test_difficult_grid_is_solvable
    g = Grid.new(DIFFICULT_SUDOKU)
    start_time = Time.now
    solvable = g.is_solvable
    puts "Difficult sudoku solved in #{Time.now - start_time} sec"
    assert_equal(true, solvable)
  end

  def test_super_difficult_grid_is_solvable
    g = Grid.new(SUPER_DIFFICULT_SUDOKU)
    start_time = Time.now
    solvable = g.is_solvable
    puts "Super difficult sudoku solved in #{Time.now - start_time} sec"
    assert_equal(true, solvable)
  end

  def test_unsolvable_grid_is_not_solvable
    g = Grid.new(UNSOLVABLE_SUDOKU)
    solvable = g.is_solvable
    assert_equal(false, solvable)
  end
end
