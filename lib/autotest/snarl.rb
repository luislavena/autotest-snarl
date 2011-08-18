require 'net/snarl'
require 'autotest/results_parser'

class Autotest
  module Snarl
    IMG_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..' , '..', 'img'))

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
          when 'test-unit'
            if results.has?('test-failed')
              notify "#{@project}: some tests failed.",
                      "#{results['test-failed']} of #{results.get('test')} failed",
                      'failed'
            elsif results.has?('test-skip')
              notify "#{@project}: some tests were skipped.",
                      "#{results['test-skip']} of #{results.get('test')} skipped",
                      'pending'
            else
              notify "#{@project}: all tests passed.",
                      "#{results.get('test')}",
                      'passed'
            end
          end
        else
          notify "#{@project}: Could not run tests.", '', 'error', true
        end
        false
      end
    end

    def self.notify(title, text, klass, sticky = false)
      snarl.notify(
        :app => 'autotest',
        :title => title,
        :text => text,
        :class => klass,
        :timeout => sticky ? 0 : 5,
        :icon => File.join(IMG_PATH, "#{klass}.png")
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
