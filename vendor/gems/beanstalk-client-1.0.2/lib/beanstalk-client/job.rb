# beanstalk-client/job.rb - client library for beanstalk

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

require 'yaml'

class Beanstalk::Job
  attr_reader :id, :body, :conn

  # Convenience method for getting ybody elements.
  def [](name)
    ybody[name]
  end

  # Convenience method for setting ybody elements.
  def []=(name, val)
    ybody[name] = val
  end

  # Return the object that results from loading the body as a yaml stream.
  # Return nil if the body is not a valid yaml stream.
  def ybody()
    (@ybody ||= [begin YAML.load(body) rescue nil end])[0]
  end

  def initialize(conn, id, body)
    @conn = conn
    @id = id
    @body = body
    @deleted = false
  end

  def delete()
    @conn.delete(id) if !@deleted
    @deleted = true
  end

  def put_back(pri=self.pri, delay=0, ttr=self.ttr)
    @conn.put(body, pri, delay, ttr)
  end

  def release(newpri=pri, delay=0)
    @conn.release(id, newpri, delay)
  end

  def bury(newpri=pri)
    @conn.bury(id, newpri)
  end

  def stats()
    @conn.job_stats(id)
  end

  def timeouts() stats['timeouts'] end
  def time_left() stats['time-left'] end
  def age() stats['age'] end
  def state() stats['state'] end
  def delay() stats['delay'] end
  def pri() stats['pri'] end
  def ttr() stats['ttr'] end

  def server()
    @conn.addr
  end

  # Don't delay for more than 48 hours at a time.
  DELAY_MAX = 60 * 60 * 48 unless defined?(DELAY_MAX)

  def decay(d=([1, delay].max * 1.3).ceil)
    return bury() if delay >= DELAY_MAX
    release(pri, d)
  end

  def to_s
    "(job #{body.inspect})"
  end

  def inspect
    "(job server=#{server} id=#{id} size=#{body.size})"
  end
end
