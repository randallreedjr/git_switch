require 'spec_helper'

RSpec.describe GitSwitch::Switcher do
  describe '#global' do
    context 'when -g is passed as first argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['-g','foo']).global).to be true
      end
    end

    context 'when -g is passed as second argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['foo','-g']).global).to be true
      end
    end

    context 'when --global is passsed as first argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['--global','foo']).global).to be true
      end
    end

    context 'when --global is passsed as second argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['foo','--global']).global).to be true
      end
    end

    context 'when no flag is passed' do
      it 'sets to false' do
        expect(GitSwitch::Switcher.new(['foo']).global).to be false
      end
    end
  end

  describe '#profile' do
    context 'when profile is only argument' do
      it 'sets correctly' do
        expect(GitSwitch::Switcher.new(['foo']).profile).to eq 'foo'
      end
    end

    context 'when profile is first argument' do
      it 'sets correctly' do
        expect(GitSwitch::Switcher.new(['foo1','-g']).profile).to eq 'foo1'
      end
    end

    context 'when profile is second argument' do
      it 'sets correctly' do
        expect(GitSwitch::Switcher.new(['--global','foo2']).profile).to eq 'foo2'
      end
    end
  end

  describe '#list' do
    context 'when -l is passed as only argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['-l']).list).to be true
      end
    end

    context 'when -l is passed as first argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['-l','foo']).list).to be true
      end
    end

    context 'when -l is passed as second argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['foo','-l']).list).to be true
      end
    end

    context 'when --list is passed as only argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['-l']).list).to be true
      end
    end

    context 'when --list is passsed as first argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['--list']).list).to be true
      end
    end

    context 'when --list is passsed as second argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['foo','--list']).list).to be true
      end
    end

    context 'when no flag is passed' do
      it 'sets to false' do
        expect(GitSwitch::Switcher.new(['foo']).list).to be false
      end
    end
  end

  describe '#run' do
    context 'in list mode' do
      let(:switcher) { GitSwitch::Switcher.new(['-l']) }
      it 'calls print_list' do
        expect(switcher).to receive(:print_list)
        switcher.run
      end
    end

    context 'in set mode' do
      let(:switcher) { GitSwitch::Switcher.new(['foo']) }
      it 'calls set!' do
        expect(switcher).to receive(:set!)
        switcher.run
      end
    end

    context 'when profile is missing' do
      let(:switcher) { GitSwitch::Switcher.new(['foo']) }
      let(:expected_output) { "Profile 'foo' not found!\n" }
      it 'prints error message' do
        expect{switcher.run}.to output(expected_output).to_stdout
      end
    end
  end

  describe '#print_list' do
    let(:switcher) { GitSwitch::Switcher.new(['-l']) }
    context 'when profiles have been configured' do
      let(:expected_output) { "personal\nwork\n" }
      it 'outputs available profiles' do
        expect{switcher.print_list}.to output(expected_output).to_stdout
      end
    end

    context 'when no profiles have been configured' do
      let(:expected_output) { '' }
      before do
        # unstub
        allow(File).to receive(:expand_path).and_call_original
        allow(File).to receive(:expand_path).and_return(File.expand_path('spec/fixtures/.empty'))
      end

      it 'outputs an empty string' do
        expect{switcher.print_list}.to output(expected_output).to_stdout
      end
    end
  end

  describe 'valid_args?' do
    let(:expected_error) { "Invalid args\n" }
    context 'when run with a single profile' do
      let(:switcher) { GitSwitch::Switcher.new(['personal']) }
      it 'returns true' do
        expect(switcher.valid_args?).to be true
      end
    end

    context 'when run with a profile and a flag' do
      let(:switcher) { GitSwitch::Switcher.new(['personal','-g']) }
      it 'returns true' do
        expect(switcher.valid_args?).to be true
      end
    end

    context 'when run with a profile and non-profile flag' do
      let(:switcher) { GitSwitch::Switcher.new(['personal','-l']) }
      it 'returns false' do
        expect(switcher.valid_args?).to be false
      end

      it 'prints error message' do
        expect{switcher.valid_args?}.to output(expected_error).to_stdout
      end
    end

    context 'when run with multiple flags' do
      let(:switcher) { GitSwitch::Switcher.new(['personal','-g','-l']) }
      it 'returns false' do
        expect(switcher.valid_args?).to be false
      end

      it 'prints error message' do
        expect{switcher.valid_args?}.to output(expected_error).to_stdout
      end
    end

    context 'when run with multiple profiles' do
      let(:switcher) { GitSwitch::Switcher.new(['personal','work']) }
      it 'returns false' do
        expect(switcher.valid_args?).to be false
      end

      it 'prints error message' do
        expect{switcher.valid_args?}.to output(expected_error).to_stdout
      end
    end

    context 'when run with no args' do
      let(:switcher) { GitSwitch::Switcher.new([]) }
      it 'returns false' do
        expect(switcher.valid_args?).to be false
      end

      it 'prints error message' do
        expect{switcher.valid_args?}.to output(expected_error).to_stdout
      end
    end
  end

  describe 'valid_profile?' do
    context 'when profile is configured' do
      let(:switcher) { GitSwitch::Switcher.new(['personal']) }
      it 'returns true' do
        expect(switcher.valid_profile?).to be true
      end
    end

    context 'when profile is not configured' do
      let(:switcher) { GitSwitch::Switcher.new(['foo']) }
      let(:expected_output) { "Profile 'foo' not found!\n" }
      it 'returns false' do
        expect(switcher.valid_profile?).to be false
      end

      it 'prints error message' do
        expect{switcher.valid_profile?}.to output(expected_output).to_stdout
      end
    end
  end
end
