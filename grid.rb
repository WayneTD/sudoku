require './cell.rb'

class Grid
  EMPTY_GRID = '0' * 81
  def initialize(grid = EMPTY_GRID)
    initialize_grid_from_text grid
  end
  
  def to_s
    values = @cells.map { |cell| cell.value }
    # slice up the array into groups of 3
    #  ==> [ [0,0,0], [0,0,0], ... [0,0,0] ]
    # then for each group of 3, join each value into a string
    #  ==> [ "000", "000", ... "000" ]
    groups_of_3 = values.each_slice(3).to_a.map {|value| value.join }
    # slice up into further groups of 3
    #  ==> [ ["000", "000", "000"], ["000", "000", "000"], ... ]
    # then join each row with a pipe
    #  ==> [ "000|000|000", "000|000|000", ... ]
    rows = groups_of_3.each_slice(3).to_a.map { |group| group.join("|") }
    # slice into 3 again and stitch them together and join them with the group row separator
    #  ==> "000|000|000---+---+---000|000|000---+---+---000|000|000..."
    rows.each_slice(3).to_a.map { |row| row.join }.join("---+---+---")
  end

  def get_cell_by_row_and_column(row, column)
    @cells.find { |cell| cell.row == row and cell.column == column }
  end
  
  def derive_possible_values
    @cells.each do |cell|
      next if cell.value != 0
      
      cell.possible_values = (1..9).find_all do |possible_value| 
        not cell.neighbouring_cell_has_value(possible_value)
      end
      
      if cell.possible_values.length == 1
        cell.value = cell.possible_values[0]
        cell.possible_values = []
      end
    end
  end
  
  def is_solvable
    solvedCellCount = solved_cell_count
    derive_possible_values
    newSolvedCellCount = solved_cell_count
    if newSolvedCellCount > solvedCellCount
      return is_solvable
    else
      if newSolvedCellCount == 81
        return true
      end
      cellWith2PossibleValues = first_cell_with_2_possible_values
      if cellWith2PossibleValues == nil
        return false
      else
        backup = clone_cells
        cellWith2PossibleValues.value = cellWith2PossibleValues.possible_values[0]
        cellWith2PossibleValues.possible_values = []
        if is_solvable
          return true
        else
          @cells = backup
          cellWith2PossibleValues = first_cell_with_2_possible_values
          if cellWith2PossibleValues == nil
            return false
          else
            cellWith2PossibleValues.value = cellWith2PossibleValues.possible_values[1]
            cellWith2PossibleValues.possible_values = []
            return is_solvable
          end
        end
      end
    end
  end

  private
    def initialize_grid_from_text(text)
      newText = text.gsub(/[-+|\s]/, '')
      raise ArgumentError, "Invalid text passed to constructor" if newText.length != 81
    
      cells = []
      cellIndex = 0
      
      (1..9).each do |rowIndex|
        (1..9).each do |columnIndex|
          cells << Cell.new(rowIndex, columnIndex, derive_group(rowIndex, columnIndex), newText[cellIndex, 1].to_i)
          cellIndex += 1
        end
      end

      derive_neighbouring_cells cells

      @cells = cells
    end
  
    def derive_group(row, column)
      if row < 4
        if column < 4
          1
        elsif column < 7
          2
        else
          3
        end
      elsif row < 7
        if column < 4
          4
        elsif column < 7
          5
        else
          6
        end
      else
        if column < 4
          7
        elsif column < 7
          8
        else
          9
        end
      end 
    end
    
    def derive_neighbouring_cells(cells)
      cells.each do |cell|
        cell.neighbouring_cells = cells.find_all do |possibleNeighbouringCell|
          cell != possibleNeighbouringCell and 
          (cell.row == possibleNeighbouringCell.row or 
           cell.column == possibleNeighbouringCell.column or 
           cell.group == possibleNeighbouringCell.group)
        end
      end
    end
    
    def solved_cell_count
      @cells.count { |cell| cell.value > 0}
    end

    def clone_cells
      cells = @cells.map { |cell| cell.clone}
      derive_neighbouring_cells cells
      cells
    end

    def first_cell_with_2_possible_values
      @cells.find { |cell| cell.possible_values.length == 2 }
    end
  end
  