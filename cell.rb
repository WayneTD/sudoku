class Cell
  attr :row, true
  attr :column,  true
  attr :group, true
  attr :value, true
  attr :possible_values, true
  attr :neighbouring_cells, true

  def initialize(row, column, group, value)
    @row = row
    @column = column
    @group = group
    @value = value
    @possible_values = []
    @neighbouring_cells = []
  end
  
  def neighbouring_cell_has_value(value)
    @neighbouring_cells.any? { |cell| cell.value == value }
  end
end