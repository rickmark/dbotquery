# frozen_string_literal: true
# rbs_inline: enabled

RSpec.describe DBotQuery::CLI, type: :cli do
  it 'fails when there is no file specified' do
    expect { run_cli 'summary' }.to output(/No value provided for required options '--file'/).to_stderr
  end

  it 'fails when the file does not exist' do
    expect do
      run_cli 'summary', '-f', 'nonexistent_file.json'
    end.to output(/File nonexistent_file.json does not exist/).to_stderr
  end

  describe 'summary' do
    it 'provides the proper count of findings with no options' do
      expect { run_cli 'summary', '-f', input_file }.to output(/"count": 120/).to_stdout
    end

    it 'provides the proper count of findings with severity option' do
      expect { run_cli 'summary', '-f', input_file, '--severity', 'high' }.to output(/"count": 54/).to_stdout
    end

    it 'provides the proper count of findings with state option' do
      expect { run_cli 'summary', '-f', input_file, '--state', 'open' }.to output(/"count": 18/).to_stdout
    end

    it 'provides the proper count of findings with severity and state options' do
      expect do
        run_cli 'summary', '-f', input_file, '--state', 'open', '--severity', 'high'
      end.to output(/"count": 8/).to_stdout
    end

    it 'errors when invalid options are provided' do
      expect do
        run_cli 'summary', '-f', input_file,
                '--gooof'
      end.to output(/ERROR: "rspec summary" was called with arguments \["--gooof"\]/).to_stderr
    end
  end
end
