require 'spec_helper'

RSpec.describe GitSwitch::GitHelper do
  describe 'git_repo?' do
    before do
      allow(File).to receive(:exists?).with('.').and_return(true)
    end
    context 'when directory has a .git file' do
      before do
        allow(File).to receive(:exists?).with(File.join(File.expand_path('.'),'.git')).and_return(true)
      end
      it 'returns true' do
        expect(GitSwitch::GitHelper.git_repo?).to be true
      end
    end

    context 'when parent directory has a .git file' do
      before do
        allow(File).to receive(:exists?).with(File.join(File.expand_path('.'),'.git')).and_return(false)
        allow(File).to receive(:exists?).with(File.join(File.expand_path('..'),'.git')).and_return(true)
      end
      it 'returns true' do
        expect(GitSwitch::GitHelper.git_repo?).to be true
      end
    end

    context 'when no parent directory has a .git file' do
      before do
        allow(File).to receive(:exists?).with(File.join(File.expand_path('.'),'.git')).and_return(false)
        allow(GitSwitch::GitHelper).to receive(:root_directory?).with(File.expand_path('.')).and_return(true)
      end
      it 'returns false' do
        expect(GitSwitch::GitHelper.git_repo?).to be false
      end
    end
  end
end
