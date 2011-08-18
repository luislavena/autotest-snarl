require 'rubygems/package_task'

# gemspec
spec = Gem::Specification.new do |s|
  s.name    = 'autotest-snarl'
  s.summary = 'Clean and stolen easy integration of Net::Snarl and autotest'
  s.version = '0.0.4'
  s.author  = 'Luis Lavena'
  s.email   = 'luislavena@gmail.com'
  s.description = <<-EOT
This makes more easy to see autotest messages using Net::Snarl
  EOT
  s.homepage = 'http://github.com/luislavena/autotest-snarl'

  s.require_path = 'lib'
  s.files = FileList[
    'Rakefile', 'lib/**/*.rb', 'img/*.png'
  ]

  s.add_dependency 'net-snarl', '~> 0.0.1'
end

# packaging
Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end
