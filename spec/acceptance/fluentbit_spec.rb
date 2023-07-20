# frozen_string_literal: true

require 'spec_helper_acceptance'
require 'pry'

describe 'fluentbit' do
  context 'basic setup' do
    it 'installs fluentbit' do
      pp = <<~EOS
        class { 'fluentbit':
        }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/etc/fluentbit-bit') do
      it { is_expected.to be_directory }
      it { is_expected.to be_readable.by('owner') }
      it { is_expected.to be_readable.by('group') }
      it { is_expected.to be_readable.by('others') }
    end

    # we need a static raft config for this
    describe package('fluentbit-bit') do
      it { is_expected.to be_installed }
    end

    describe service('fluentbitbit') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
