require 'spec_helper'

RSpec.describe GitSwitch::Options do
  let(:options) { GitSwitch::Options.new(args) }

  describe 'valid_args?' do
    let(:expected_error) { "Invalid args\n" }
    context 'when run with a single profile' do
      let(:args) { ['personal' ] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end

    context 'when run with a profile and a flag' do
      let(:args) { ['personal','-g'] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end

    context 'when run with a profile and non-profile flag' do
      let(:args) { ['personal','-l'] }

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

      it 'returns false' do
        expect(options.valid_args?).to be false
      end

      it 'prints error message' do
        expect{options.valid_args?}.to output(expected_error).to_stdout
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
end
