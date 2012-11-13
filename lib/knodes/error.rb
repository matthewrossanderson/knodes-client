module Knodes
  # Custom error class for rescuing from all Knodes errors
  class Error < StandardError; end

  # Raised when Knodes returns the HTTP status code 400
  class BadRequest < Error; end

  # Raised when Knodes returns the HTTP status code 404
  class NotFound < Error; end
end