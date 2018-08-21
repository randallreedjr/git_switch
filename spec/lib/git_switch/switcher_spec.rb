require 'spec_helper'

RSpec.describe GitSwitch::Switcher do
  before do
    allow(File).to receive(:expand_path).and_return(File.expand_path('spec/fixtures/.gitswitch'))
  end

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
      it 'calls print_list' do
        expect(switcher).to receive(:set!)
        switcher.run
      end
    end
  end

  describe '#print_list' do
    let(:switcher) { GitSwitch::Switcher.new(['-l']) }
    let(:expected_output) { "personal\nwork\n" }
    it 'outputs available profiles' do
      expect{switcher.print_list}.to output(expected_output).to_stdout
    end
  end
end
