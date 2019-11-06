require "test_helper"

class GitfunTest < Minitest::Test
  def run_command(*args)
    @input = StringIO.new
    @output = StringIO.new
    HighLine.default_instance = HighLine.new(@input, @output)
    Commander::Runner.instance_variable_set :"@singleton", Commander::Runner.new(args)
    Gitfun.run!
    @output.string
  end

  def test_that_it_has_a_version_number
    refute_nil ::Gitfun::VERSION
  end

  def test_it_does_something_useful
    assert_match(/\-+help/, run_command('--help'))
  end
end
