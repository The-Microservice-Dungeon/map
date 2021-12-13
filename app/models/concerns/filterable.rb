# frozen_string_literal: true

##
# Filterable
#
# This code is filtering the results of a query based on the parameters passed in.
# The code block iterates through each key and value pair calling a method that matches
# the key name with filter by prepended to it. If there is a value present for that
# parameter then we call this method passing in the value as an argument. This allows
# us to filter by multiple parameters at once without having to write out separate
# methods for each one
module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      results = where(nil)
      filtering_params.each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end
  end
end
