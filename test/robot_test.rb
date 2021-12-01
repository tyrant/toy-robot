require 'test/unit'
require_relative '../lib/robot'

class RobotTest < Test::Unit::TestCase

  # First, let's verify that the three README demo examples do in fact 
  # do what they say on the tin:
  def test_demo1
    input = <<~HEREDOC
      PLACE 0,0,NORTH
      MOVE
      REPORT
    HEREDOC
    assert_equal Robot.new(input).run, '0,1,NORTH'
  end

  def test_demo2
    input = <<~HEREDOC
      PLACE 0,0,NORTH
      LEFT
      REPORT
    HEREDOC
    assert_equal Robot.new(input).run, '0,0,WEST'
  end

  def test_demo3
    input = <<~HEREDOC
      PLACE 1,2,EAST
      MOVE
      MOVE
      LEFT
      MOVE
      REPORT
    HEREDOC
    assert_equal Robot.new(input).run, '3,3,NORTH'
  end


  # Let's branch out. First, verify that all commands of any type will be ignored
  # before the first PLACE command.
  def test_ignore_all_commands_before_place
    input = <<~HEREDOC
      MOVE
      MOVE
      LEFT
      RIGHT
      UP 
      UP
      DOWN
      DOWN
      LEFT
      RIGHT
      LEFT 
      RIGHT
      B
      A
      PLACE 0,0,NORTH
      MOVE
      REPORT
    HEREDOC
    assert_equal Robot.new(input).run, '0,1,NORTH'
  end


  # What happens if we squirt at our robot a gazillion MOVE commands?
  # The robot should halt at the table's northern edge.
  def test_a_gzillion_move_commands
    input = <<~HEREDOC
      PLACE 0,0,NORTH
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      MOVE
      REPORT
    HEREDOC
    assert_equal Robot.new(input).run, '0,4,NORTH'
  end

  # What happens if the initial PLACE command is off the table?
  # Our only README spec is L48-51: "the toy robot must not fall off the table
  # during movment. This also includes the initial placement of the toy robot. 
  # Any move that would cause the robot to fall must be ignored."
  # Ignored. Right.
  def test_invalid_line_command
    input = <<~HEREDOC
      PLACE 0,1000,NORTH
      MOVE
      REPORT
    HEREDOC
    assert_equal Robot.new(input).run, 'The robot is not on the table.'
  end


  # The README mentions multiple PLACE commands, L33. It doesn't specify exactly
  # how this should be implemented ... but it's a fairly safe bet that you'd
  # just simply pluck the robot off the table and place it at its new 
  # coordinates and ignore all previous commands. Simple.
  def test_multiple_place_commands
    input = <<~HEREDOC
      PLACE 0,0,NORTH
      MOVE
      MOVE
      MOVE
      PLACE 3,3,SOUTH
      MOVE
      MOVE
      REPORT
    HEREDOC
    assert_equal Robot.new(input).run, '3,1,SOUTH'
  end
end