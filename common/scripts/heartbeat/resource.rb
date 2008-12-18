# -*- coding: utf-8 -*-
module Heatbeat
  # heatbeat のリソースを表現する抽象クラス。
  class Resource
    DEFAULT_TIMEOUT = 10

    PIDOF_COMMAND = "/bin/pidof"

    def self.inherited(obj)
      obj.send(:define_method, :name,
               Proc.new {
                 obj.name.slice(/([^:]+)$/, 1).downcase
               })
    end
    
    def self.run(argv)
      begin
        resource = self.new
        return resource.run(argv)
      rescue Resource::Error => e
        puts(e)
        return 1
      end
    end
    
    def run(argv)
      mode = find_mode(argv)
      if mode.nil?
        puts(usage)
        return 0
      end
      return send(mode.to_sym) ? 0 : 1
    end

    def find_mode(argv)
      return argv.grep(/start|stop|status/).first
    end

    def usage
      return "Usage: #{name} {start|stop|status}."
    end

    def start
      return true
    end

    def stop
      return true
    end

    def status
      if check_status
        puts("#{name} running")
        return true
      else
        puts("#{name} not running")
        return false
      end
    end

    def check_status
      return true
    end

    def execute(command)
      res = `#{command}`
      if $? != 0
        raise Resource::Error, "failed the command: #{command}"
      end
      return res
    end

    def pidof(process_name)
      return execute("#{PIDOF_COMMAND} #{process_name}").split.collect { |i| i.to_i }
    end

    def killall(signal, pids)
      pids.each do |pid|
        begin
          Process.kill(signal, pid)
        rescue Errno::ENOENT, Errno::ESRCH
        end
      end
      Timeout.timeout(DEFAULT_TIMEOUT, Resource::TimeoutException) do
        while pids.length > 0
          pids = pids.delete_if { |pid|
            res = false
            begin
              Process.kill(0, pid)
            rescue Errno::ENOENT, Errno::ESRCH
              res = true
            end
            res
          }
          sleep(0.1)
        end
      end
      return true
    end

    class Error < StandardError
    end

    class TimeoutException < Error
    end
  end
end
