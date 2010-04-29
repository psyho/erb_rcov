class ErbCoverageInvocationAdder

  attr_reader :file_name, :file_contents

  def initialize(file_name, file_contents)
    @file_name = file_name
    @file_contents = file_contents
  end

  def augumented_file_contents
    output = ''    
    index = 0
    open_blocks = 0
    start_index = 0
    end_index = 0

    code_to_output = ''

    # TODO: counting "braces"

    self.file_contents.each_line do |line|
      if open_blocks == 0
        start_index = index
        end_index = index
      else
        end_index += 1
      end

      output << tracking_code(index)

      output << line
      index += 1
    end
    output << tracking_code(index) if index == 0
    return output
  end

  private

  def tracking_code(line, end_line = nil)
    "<% ::ErbRcovDataGatherer.register_invocation('#{file_name}', #{line}, #{", #{end_line}" if end_line}) %>"
  end
  
end