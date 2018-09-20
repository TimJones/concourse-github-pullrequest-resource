# frozen_string_literal: true

module Filters
  class BranchRegex
    def initialize(pull_requests:, input: Input.instance)
      @pull_requests = pull_requests
      @input = input
    end

    def pull_requests
      branch_regex = @input.source.branch_regex || ""

      return @pull_requests if branch_regex.empty?

      @memoized ||= @pull_requests.keep_if do |pr|
        pr.ref =~ /#{branch_regex}/
      end
    end
  end
end
