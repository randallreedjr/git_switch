require 'spec_helper'

RSpec.describe GitSwitch::Options do
  let(:options) { GitSwitch::Options.new(args) }

  describe 'flags' do
    context 'when short flags are used' do
      context 'when run in list mode' do
        let(:args) { ['-l'] }
        it 'returns an empty array' do
          expect(options.flags).to eq ['-l']
        end
      end

      context 'when run in global mode' do
        let(:args) { ['personal', '-g'] }
        it 'returns an empty array' do
          expect(options.flags).to eq ['-g']
        end
      end

      context 'when run with multiple flags' do
        let(:args) { ['personal', '-g', '-v'] }
        it 'returns an empty array' do
          expect(options.flags).to eq ['-g', '-v']
        end
      end

      context 'when run with invalid flags' do
        let(:args) { ['personal', '-a', '-gv'] }
        it 'returns an empty array' do
          expect(options.flags).to eq []
        end
      end
    end

    context 'when long flags are used' do
      context 'when run in list mode' do
        let(:args) { ['--list'] }
        it 'returns an empty array' do
          expect(options.flags).to eq ['--list']
        end
      end

      context 'when run in global mode' do
        let(:args) { ['personal', '--global'] }
        it 'returns an empty array' do
          expect(options.flags).to eq ['--global']
        end
      end

      context 'when run with multiple flags' do
        let(:args) { ['personal', '--global', '--verbose'] }
        it 'returns an empty array' do
          expect(options.flags).to eq ['--global', '--verbose']
        end
      end

      context 'when run with invalid flags' do
        let(:args) { ['personal', '--foo', '--globalist'] }
        it 'returns an empty array' do
          expect(options.flags).to eq []
        end
      end
    end

    context 'when run with no flags' do
      let(:args) { ['personal'] }
      it 'returns an empty array' do
        expect(options.flags).to eq []
      end
    end
  end

  describe 'valid_args?' do
    let(:expected_error) { "Invalid args\n" }

    context 'when run with a single profile' do
      let(:args) { ['personal'] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end

    context 'when run with a profile and a flag' do
      let(:args) { ['personal', '-g'] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end

    context 'when run with a profile and non-profile flag' do
      let(:args) { ['personal', '-l'] }

      it 'returns false' do
        expect(options.valid_args?).to be false
      end

      it 'prints error message' do
        expect{options.valid_args?}.to output(expected_error).to_stdout
      end
    end

    context 'when run with multiple flags' do
      let(:args) { ['personal','-g','-l'] }
      let(:options) { GitSwitch::Options.new(args) }

      it 'returns false' do
        expect(options.valid_args?).to be false
      end

      it 'prints error message' do
        expect{options.valid_args?}.to output(expected_error).to_stdout
      end
    end

    context 'when run with multiple profiles' do
      let(:args) { ['personal','work'] }

      it 'returns false' do
        expect(options.valid_args?).to be false
      end

      it 'prints error message' do
        expect{options.valid_args?}.to output(expected_error).to_stdout
      end
    end

    context 'when run with no args' do
      let(:args) { [] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end
  end

  describe 'usage?' do
    context 'when there are no args' do
      let(:args) { [] }
      it 'returns true' do
        expect(options.usage?).to be true
      end
    end

    context 'with a profile' do
      let(:args) { ['foo'] }
      it 'returns false' do
        expect(options.usage?).to be false
      end
    end

    context 'with a flag' do
      let(:args) { ['-l'] }
      it 'returns false' do
        expect(options.usage?).to be false
      end
    end
  end

  describe 'list?' do
    context 'when args includes -l' do
      let(:args) { ['-l'] }
      it 'returns true' do
        expect(options.list?).to be true
      end
    end

    context 'when args includes --list' do
      let(:args) { ['--list'] }
      it 'returns true' do
        expect(options.list?).to be true
      end
    end

    context 'when args do not include -l or --list' do
      let(:args) { [] }
      it 'returns false' do
        expect(options.list?).to be false
      end
    end
  end

  describe 'global?' do
    context 'when args includes -g' do
      let(:args) { ['-g'] }
      it 'returns true' do
        expect(options.global?).to be true
      end
    end

    context 'when args includes --global' do
      let(:args) { ['--global'] }
      it 'returns true' do
        expect(options.global?).to be true
      end
    end

    context 'when args do not include -g or --global' do
      let(:args) { [] }
      it 'returns false' do
        expect(options.global?).to be false
      end
    end
  end

  describe 'verbose?' do
    context 'when args includes -v' do
      let(:args) { ['-v'] }
      it 'returns true' do
        expect(options.verbose?).to be true
      end
    end

    context 'when args includes --verbose' do
      let(:args) { ['--verbose'] }
      it 'returns true' do
        expect(options.verbose?).to be true
      end
    end

    context 'when args do not include -v or --verbose' do
      let(:args) { [] }
      it 'returns false' do
        expect(options.verbose?).to be false
      end
    end
  end
end
