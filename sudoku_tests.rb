require 'test/unit'
require 'benchmark' 
on_windows = ENV['windir'] != nil
require on_windows ? '.\sudoku.rb' : './sudoku.rb'  
  
EMPTY_SUDOKU = 
  "000|000|000" +
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
      
EASY_SUDOKU = '050306007000085024098420603901003206030000010507260908405090380010570002800104070'      
DIFFICULT_SUDOKU = '510060000008000000060010702900074001003608070000000450000000940090000000300240000'
SUPER_DIFFICULT_SUDOKU = '000000000000390280040021093600070900900502006005060001180250030064018000000000000'
UNSOLVABLE_SUDOKU = '059306007000085024098420603901003206030000010507260908405090380010570002800104070' #Same as DIFFICULT_SUDOKU with rogue 9 value in third cell

class GridTests < Test::Unit::TestCase
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
    assert_equal(DIFFICULT_SUDOKU, g.to_s.gsub(/[-+|\s]/, ''))
  end

  def test_easy_grid_is_solvable
    g = Grid.new(EASY_SUDOKU)
    Benchmark.bm(10) do |x|
      x.report("Easy Sudoku") { assert_equal(true, g.is_solvable) }
    end
  end

  def test_difficult_grid_is_solvable
    g = Grid.new(DIFFICULT_SUDOKU)
    Benchmark.bm(10) do |x|
      x.report("Difficult Sudoku") { assert_equal(true, g.is_solvable) }
    end
  end

  def test_super_difficult_grid_is_solvable
    g = Grid.new(SUPER_DIFFICULT_SUDOKU)
    Benchmark.bm(10) do |x|
      x.report("Super Difficult Sudoku") { assert_equal(true, g.is_solvable) }
    end
  end

  def test_unsolvable_grid_is_not_solvable
    g = Grid.new(UNSOLVABLE_SUDOKU)
    solvable = g.is_solvable
    assert_equal(false, solvable)
  end
end
