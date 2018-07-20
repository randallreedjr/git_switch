require 'spec_helper'

RSpec.describe GitSwitch::Switcher do
  describe '#global' do
    context 'when -g is passed as first argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['-g','foo']).global).to be true
      end
    end
    context 'when -g is passed as first argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['foo','-g']).global).to be true
      end
    end

    context 'when --global is passsed as first argument' do
      it 'sets to true' do
        expect(GitSwitch::Switcher.new(['--global','foo']).global).to be true
      end
    end

    context 'when --global is passsed as first argument' do
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
end
