require 'rubygems'
require 'rake/gempackagetask'

def read_version
  File.open('ext/lhalib.c').each_line do |x|
    m = /LHALIB_VERSION\s+"(.+?)"/.match(x)
    if m
      return m[1]
    end
  end
  nil
end

desc "Default Task"
task :default => [ :package ]

spec = Gem::Specification.new do |s|
  s.authors = 'arton'
  s.email = 'artonx@gmail.com'
  if /mswin32|mingw/ =~ RUBY_PLATFORM
    s.platform = Gem::Platform::WIN32
  else
    s.platform = Gem::Platform::RUBY
    s.extensions << 'ext/extconf.rb'
  end
  s.required_ruby_version = '>= 1.8.2'
  s.summary = 'Ruby LHa Lib'
  s.name = 'lhalib'
  s.homepage = 'http://arton.no-ip.info/collabo/backyard/?LhaLib'
  s.version = read_version
  s.requirements << 'none'
  s.require_path = 'lib'
  files = FileList['ext/*.c', 'ext/*.h', 'ext/depend',
                   'samples/**/*.rb', 'test/**/*.org', 'test/**/*.lzh',
                   'test/*.rb', 'COPYING', 'ChangeLog', 'readme.*', '*.rb']
  if /mswin32/ =~ RUBY_PLATFORM
    File.cp 'ext/lhalib.so', 'lib/lhalib.so'
    files << "lib/lhalib.so"
    s.requirements << ' VC6 version of Ruby' 
  end
  s.files = files
  s.test_file = 'test/test.rb'
  s.description = <<EOD
LhaLib is an utility that unpack the LHa archived file.
EOD
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
  pkg.need_zip = false
  pkg.need_tar = false
end
