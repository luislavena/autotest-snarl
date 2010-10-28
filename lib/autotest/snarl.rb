require 'net/snarl'
require 'autotest/results_parser'

class Autotest
  module Snarl
    Autotest.add_hook :run_command do
      @project = File.basename(Dir.pwd)
    end

    Autotest.add_hook :ran_command do |autotest|
      unless @ran_tests
        results = Autotest::ResultsParser.new(autotest)
        if results.exists?
          case results.framework
          when 'rspec'
            if results.has?('example-failed')
              notify "#{@project}: some examples failed.",
                      "#{results['example-failed']} of #{results.get('example')} failed",
                      'failed'
            elsif results.has?('example-pending')
              notify "#{@project}: some examples are pending.",
                      "#{results['example-pending']} of #{results.get('example')} pending",
                      'pending'
            else
              notify "#{@project}: all examples passed.",
                      "#{results.get('example')}",
                      'passed'
            end
          end
        else
          notify "#{@project}: Could not run tests.", '', 'error', true
        end
        false
      end
    end

    def self.notify(title, message, klass, sticky = false)
      snarl.notify(
        :app => 'autotest',
        :title => title,
        :message => message,
        :class => klass,
        :timeout => sticky ? 0 : 5,
        :icon => File.expand_path("~/.snarl/#{klass}.png")
      )
    end

    def self.snarl
      return @@snarl if defined?(@@snarl)

      @@snarl = Net::Snarl.new
      @@snarl.register('autotest')
      @@snarl.add_class('autotest', 'passed')
      @@snarl.add_class('autotest', 'failed')
      @@snarl.add_class('autotest', 'pending')
      @@snarl.add_class('autotest', 'error')
      @@snarl
    end
  end
end
