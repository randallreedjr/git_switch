require 'spec_helper'

RSpec.describe GitSwitch::Config do
  describe 'valid_profile?' do
    context 'when profile is configured' do
      let(:config) { GitSwitch::Config.new(['personal']) }
      it 'returns true' do
        expect(config.valid_profile?).to be true
      end
    end

    context 'when profile is not configured' do
      let(:config) { GitSwitch::Config.new(['foo']) }
      let(:expected_output) { "Profile 'foo' not found!\n" }
      it 'returns false' do
        expect(config.valid_profile?).to be false
      end

      it 'prints error message' do
        expect{config.valid_profile?}.to output(expected_output).to_stdout
      end
    end
  end

  describe '#print_list' do
    let(:config) { GitSwitch::Config.new(['-l']) }
    context 'when profiles have been configured' do
      context 'when no profiles are active' do
        let(:expected_output) { "   personal\n   work\n" }
        it 'outputs available profiles' do
          expect{config.print_list}.to output(expected_output).to_stdout
        end
      end

      context 'when a profile is active' do
        before do
          allow(config).to receive(:current_git_username).and_return('johnnyfive')
        end
        let(:expected_output) { "=> personal\n   work\n\n# => - current\n" }
        it 'indicates the active profile' do
          expect{config.print_list}.to output(expected_output).to_stdout
        end
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
        expect{config.print_list}.to output(expected_output).to_stdout
      end
    end
  end
end
