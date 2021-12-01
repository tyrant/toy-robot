class Robot

  VALID_COMMANDS = %w(PLACE MOVE LEFT RIGHT REPORT)
  VALID_DIRECTIONS = %w(NORTH EAST SOUTH WEST) # Order is important! FIXME brittle?
  VALID_XS = 0..4
  VALID_YS = 0..4

  attr_accessor :inputs, :x, :y, :f, :placed


  # If we wished, we could shove some per-Robot valid-attr-overrides here
  def initialize(input)
    _preprocess(input)
  end


  # _preprocess has already confirmed that the first input will be a PLACE.
  def run
    @inputs.each do |line|
      if line[0..4] == 'PLACE'
        _place_robot_at(line.split(' ')[1])
      elsif line == 'MOVE'
        _move_robot
      elsif line == 'LEFT'
        _rotate_robot_left
      elsif line == 'RIGHT'
        _rotate_robot_right
      elsif line == 'REPORT'
        break
      else
        raise "Oh come on"
      end        
    end

    _build_report
  end


  # Basically what it says on the tin: does `maybe_line` match PLACE x,y,DIRECTION?
  # Are x and y inside valid_x/ys? Is DIRECTION a direction?
  def Robot.valid_line_command?(maybe_line)
    x_y_dir = maybe_line.split(' ')[1].split(',')

    x_in_range = VALID_XS.include? x_y_dir[0].to_i
    y_in_range = VALID_YS.include? x_y_dir[1].to_i
    valid_direction = VALID_DIRECTIONS.include? x_y_dir[2]

    x_in_range && y_in_range && valid_direction
  end


  private


  def _place_robot_at(location)
    xyf = location.split(',')

    @x = xyf[0].to_i
    @y = xyf[1].to_i
    @f = xyf[2]
  end


  # Move our Robot one unit in whatever direction we've got stored in @f. 
  # Don't go outside our valid_x/y bounds!
  def _move_robot
    case @f
    when 'NORTH'
      @y = [@y+1, VALID_YS.max].min
    when 'EAST'
      @x = [@x+1, VALID_XS.max].min
    when 'SOUTH'
      @y = [@y-1, VALID_YS.min].max
    when 'WEST'
      @x = [@x-1, VALID_XS.min].max
    end
  end


  def _rotate_robot_left
    current_index = VALID_DIRECTIONS.index(@f)
    @f = VALID_DIRECTIONS[(current_index - 1) % 4]
  end


  def _rotate_robot_right
    current_index = VALID_DIRECTIONS.index(@f)
    @f = VALID_DIRECTIONS[(current_index + 1) % 4]
  end


  def _build_report
    if @placed
      "#{@x},#{@y},#{@f}"
    else
      'The robot is not on the table.'
    end
  end


  # We're expecting @input to be a newline-separated list of commands.
  # We could go really nuts here with all kinds of fiddly validations.
  # I'm open to the theoretical possibility that users aren't complete bastards.
  def _preprocess(input)
    @inputs = []
    @placed = false

    # Let's skip past and disregard any input commands not explicitly validated.
    input.split("\n").each do |line|
      next unless VALID_COMMANDS.any?{|c| line.include?(c) }

      if line[0..4] == 'PLACE'
        if Robot.valid_line_command?(line)
          @inputs << line
          @placed = true
        end
      else
        next unless @placed
        @inputs << line
      end
    end
  end
end