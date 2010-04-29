require File.join(File.dirname(__FILE__), 'test_helper')

class ErbCoverageInvocationAdderTest < Test::Unit::TestCase

  def tracking_code(file, line_start, line_end = nil)
    "<% ::ErbRcovDataGatherer.register_invocation('#{file}', #{line_start}#{", #{line_end}" if line_end}) %>"
  end

  def assert_code_augumented(code, expected_result)
    result = ErbCoverageInvocationAdder.new(@file_name, code).augumented_file_contents
    assert_equal expected_result, result, "Expected augumented code to look like this:\n#{expected_result}\nbut it looked like this:\n#{result}"
  end

  def setup
    @file_name = "/some/file/name.erb"
  end

  def test_adding_invocations_to_empty_file
    assert_code_augumented "", tracking_code(@file_name, 0)
  end

  def test_adding_invocations_to_single_line_ruby_code
    code = "<% x = 0 %>"
    assert_code_augumented code, tracking_code(@file_name, 0) + code
  end

  def test_adding_invocations_to_single_line_ruby_expression
    code = "<%= x = 0 %>"
    assert_code_augumented code, tracking_code(@file_name, 0) + code
  end

  def test_adding_invocations_to_single_line_ruby_comment
    code = "<%# some stupid comment %>"
    assert_code_augumented code, tracking_code(@file_name, 0) + code
  end

  def test_adding_invocations_to_single_line_ruby_escaped_delimiters
    code = "<%% some stupid comment %%>"
    assert_code_augumented code, tracking_code(@file_name, 0) + code
  end

  def test_adding_invocations_to_multiline_expression
    code = <<-ERB
    <%= some_helper :foo => 1,
      :bar => 1,
      :baz => 1
    %>
    ERB
    assert_code_augumented code, tracking_code(@file_name, 0, 3) + code
  end

  #multiline code

  #if with body

  # many expressions at once

end