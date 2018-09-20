# frozen_string_literal: true

require_relative '../../assets/lib/filters/branch_regex'
require_relative '../../assets/lib/pull_request'
require 'webmock/rspec'

describe Filters::BranchRegex do
  let(:ignore_pr) do
    PullRequest.new(pr: { 'number' => 1, 'head' => { 'ref' => 'abc' } })
  end

  let(:pr) do
    PullRequest.new(pr: { 'number' => 2, 'head' => { 'ref' => 'def' } })
  end

  let(:pull_requests) { [ignore_pr, pr] }

  context 'when branch_regex is not specified' do
    it 'does not filter' do
      payload = { 'source' => { 'repo' => 'user/repo' } }
      filter = described_class.new(pull_requests: pull_requests, input: Input.instance(payload: payload))

      expect(filter.pull_requests).to eq pull_requests
    end
  end

  context 'when branch_regex is specified' do
    it 'only returns PRs with that a matching branch ref' do
      payload = { 'source' => { 'repo' => 'user/repo', 'branch_regex' => '^d' } }
      filter = described_class.new(pull_requests: pull_requests, input: Input.instance(payload: payload))

      expect(filter.pull_requests).to eq [pr]
    end
  end
end
