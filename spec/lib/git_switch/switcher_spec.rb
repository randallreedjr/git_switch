require 'spec_helper'

RSpec.describe GitSwitch::Switcher do
  describe '#global?' do
    context 'when -g is passed as first argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['-g','foo']).global?).to be true
      end
    end

    context 'when -g is passed as second argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['foo','-g']).global?).to be true
      end
    end

    context 'when --global is passsed as first argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['--global','foo']).global?).to be true
      end
    end

    context 'when --global is passsed as second argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['foo','--global']).global?).to be true
      end
    end

    context 'when no flag is passed' do
      it 'sets to false' do
        expect(GitSwitch::Switcher.new(['foo']).global?).to be false
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

  describe '#config?' do
    context 'when -c is passed as only argument' do
      it 'returns true' do
        expect(GitSwitch::Switcher.new(['-c']).config?).to be true
      end
    end

    context 'when -c is passed as first argument' do
      it 'returns false' do
        expect(GitSwitch::Switcher.new(['-c','foo']).config?).to be false
      end
    end

    context 'when -c is passed as second argument' do
      it 'returns false' do
        expect(GitSwitch::Switcher.new(['foo','-c']).config?).to be false
      end
    end

    context 'when --config is passed as only argument' do
      it 'returns true' do
        expect(GitSwitch::Switcher.new(['--config']).config?).to be true
      end
    end

    context 'when --config is passsed as first argument' do
      it 'returns false' do
        expect(GitSwitch::Switcher.new(['--config', 'foo']).config?).to be false
      end
    end

    context 'when --config is passsed as second argument' do
      it 'returns false' do
        expect(GitSwitch::Switcher.new(['foo','--config']).config?).to be false
      end
    end

    context 'when no flag is passed' do
      it 'returns false' do
        expect(GitSwitch::Switcher.new(['foo']).config?).to be false
      end
    end
  end

  describe '#list?' do
    context 'when -l is passed as only argument' do
      it 'returns true' do
        expect(GitSwitch::Switcher.new(['-l']).list?).to be true
      end
    end

    context 'when -l is passed as first argument' do
      it 'returns false' do
        expect(GitSwitch::Switcher.new(['-l','foo']).list?).to be false
      end
    end

    context 'when -l is passed as second argument' do
      it 'returns false' do
        expect(GitSwitch::Switcher.new(['foo','-l']).list?).to be false
      end
    end

    context 'when --list is passed as only argument' do
      it 'returns true' do
        expect(GitSwitch::Switcher.new(['--list']).list?).to be true
      end
    end

    context 'when --list is passsed as first argument' do
      it 'returns false' do
        expect(GitSwitch::Switcher.new(['--list', 'foo']).list?).to be false
      end
    end

    context 'when --list is passsed as second argument' do
      it 'returns false' do
        expect(GitSwitch::Switcher.new(['foo','--list']).list?).to be false
      end
    end

    context 'when no flag is passed' do
      it 'returns false' do
        expect(GitSwitch::Switcher.new(['foo']).list?).to be false
      end
    end
  end

  describe '#run' do
    context 'with no args' do
      let(:switcher) { GitSwitch::Switcher.new([]) }
      it 'calls print_usage' do
        expect(switcher).to receive(:print_usage)
        switcher.run
      end
    end

    context 'in config mode' do
      let(:switcher) { GitSwitch::Switcher.new(['-c']) }
      it 'calls configure' do
        expect(switcher).to receive(:configure!).and_call_original
        expect(switcher.config).to receive(:configure!)
        switcher.run
      end
    end

    context 'in list mode' do
      let(:switcher) { GitSwitch::Switcher.new(['-l']) }
      it 'calls print_list' do
        expect(switcher).to receive(:print_list).and_call_original
        expect(switcher.config).to receive(:print_list)
        switcher.run
      end
    end

    context 'in set mode' do
      let(:switcher) { GitSwitch::Switcher.new(['personal']) }
      let(:options) { switcher.options }

      it 'calls set!' do
        expect(switcher).to receive(:set!)
        switcher.run
      end

      it 'checks for valid args' do
        expect(options).to receive(:valid_args?)
        switcher.run
      end

      it 'checks for valid profile' do
        expect(switcher.config).to receive(:valid_profile?)
        switcher.run
      end

      it 'checks for git repo' do
        expect(switcher).to receive(:git_repo?)
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

  describe '#set!' do
    before do
      allow(switcher).to receive(:set_git_config) {}
      allow(switcher).to receive(:set_ssh) {}
    end

    let(:switcher) { GitSwitch::Switcher.new(['personal']) }

    context 'when run with -g flag' do
      let(:switcher) { GitSwitch::Switcher.new(['personal', '-g']) }
      it 'calls set_git_config with global flag' do
        expect(switcher).to receive(:set_git_config).with('--global')
        switcher.run
      end
    end

    context 'when run with --global flag' do
      let(:switcher) { GitSwitch::Switcher.new(['personal', '--global']) }
      it 'calls set_git_config with global flag' do
        expect(switcher).to receive(:set_git_config).with('--global')
        switcher.run
      end
    end

    it 'calls set_ssh' do
      expect(switcher).to receive(:set_ssh)
      switcher.run
    end

    it 'calls print_settings' do
      expect(switcher).to receive(:print_settings)
      switcher.run
    end
  end

  describe '#print_settings' do
    context 'when called with --verbose flag' do
      let(:switcher) { GitSwitch::Switcher.new(['personal', '--verbose']) }
      it 'prints all settings' do
        expect{switcher.print_settings}.to output(/\nGit Config:/).to_stdout
        expect{switcher.print_settings}.to output(/\nSSH:/).to_stdout
      end
    end
    context 'when called with -v flag' do
      let(:switcher) { GitSwitch::Switcher.new(['personal', '--verbose']) }
      it 'prints all settings' do
        expect{switcher.print_settings}.to output(/\nGit Config:/).to_stdout
        expect{switcher.print_settings}.to output(/\nSSH:/).to_stdout
      end
    end
    context 'when called without --verbose or -v flag' do
      let(:switcher) { GitSwitch::Switcher.new(['personal']) }
      it 'does  not print all settings' do
        expect{switcher.print_settings}.to_not output(/\nGit Config:/).to_stdout
        expect{switcher.print_settings}.to_not output(/\nSSH:/).to_stdout
      end

      it 'prints confirmation message' do
        expect{switcher.print_settings}.to_not output("/nSwitched to profile personal").to_stdout
      end
    end
  end

  describe '#print_usage' do
    let(:switcher) { GitSwitch::Switcher.new([]) }
    let(:expected_output) do
      <<~USAGE
      usage: git switch [-l | --list] [-c | --config]
                        <profile> [-v | --verbose] [-g | --global]

      configure profiles
          git switch -c

      switch to a profile for local development only
          git switch <profile>

      switch to a profile globally
          git switch -g <profile>

      switch to a profile and see all output
          git switch -v <profile>

      see available profiles
          git switch -l
      USAGE
    end

    it 'outputs usage details' do
      expect{switcher.print_usage}.to output(expected_output).to_stdout
    end
  end

  describe 'git_repo?' do
    let(:switcher) { GitSwitch::Switcher.new(['personal']) }
    context 'when GitHelper returns true' do
      before do
        allow(GitSwitch::GitHelper).to receive(:git_repo?).and_return(File.expand_path('.'))
      end
      it 'returns true' do
        expect(switcher.git_repo?).to be true
      end
    end

    context 'when GitHelper returns nil' do
      before do
        allow(GitSwitch::GitHelper).to receive(:git_repo?).and_return(nil)
      end

      context 'when run with global flag' do
        let(:switcher) { GitSwitch::Switcher.new(['personal','-g']) }
        it 'returns true' do
          expect(switcher.git_repo?).to be true
        end
      end

      context 'when run without global flag' do
        let(:expected_error) { "Not a git repo. Please run from a git repo or run with `-g` to update global settings.\n" }
        it 'returns false' do
          expect(switcher.git_repo?).to be false
        end

        it 'prints error message' do
          expect{switcher.git_repo?}.to output(expected_error).to_stdout
        end
      end
    end
  end
end
