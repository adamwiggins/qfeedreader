# beanstalk-client/errors.rb - client library for beanstalk

# Copyright (C) 2007 Philotic Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

module Beanstalk
  class NotConnected < RuntimeError
  end

  class UnexpectedResponse < RuntimeError
    def self.subclasses
      @classes ||= []
    end

    def self.inherited(subclass)
      subclasses << subclass
    end

    def self.classify(word, message)
      for clas in subclasses
        return clas.new(message) if clas::WORD == word
      end
      return new(message)
    end
  end

  class DrainingError < UnexpectedResponse
    WORD = 'DRAINING'
  end

  class NotFoundError < UnexpectedResponse
    WORD = 'NOT_FOUND'
  end

  class DeadlineSoonError < UnexpectedResponse
    WORD = 'DEADLINE_SOON'
  end

  class NotIgnoredError < UnexpectedResponse
    WORD = 'NOT_IGNORED'
  end

  class OutOfMemoryError < UnexpectedResponse
    WORD = 'OUT_OF_MEMORY'
  end

  class InternalError < UnexpectedResponse
    WORD = 'INTERNAL_ERROR'
  end

  class BadFormatError < UnexpectedResponse
    WORD = 'BAD_FORMAT'
  end

  class UnknownCommandError < UnexpectedResponse
    WORD = 'UNKNOWN_COMMAND'
  end

  class ExpectedCRLFError < UnexpectedResponse
    WORD = 'EXPECTED_CRLF'
  end

  class JobTooBigError < UnexpectedResponse
    WORD = 'JOB_TOO_BIG'
  end

  class TimedOut < UnexpectedResponse
    WORD = 'TIMED_OUT'
  end

  class WaitingForJobError < RuntimeError
  end

  class InvalidTubeName < RuntimeError
  end
end
