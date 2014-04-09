Gem::Specification.new do |s|
  s.name        = 'dotdash'
  s.version     = '0.0.1'
  s.date        = '2014-04-08'
  s.summary     = "A dotfile manager"
  s.description = "Managing dotfiles through a Git backend"
  s.authors     = ["Nick Herson"]
  s.email       = 'nicholas.herson@gmail.com'
  s.homepage    =
  'http://github.com/nherson/dotdash'
  s.license       = 'GPLv2'

  # Files
  s.files       = ["lib/dotdash.rb"]
  # Executables
  s.executables << 'dotdash'
  # Dependencies
  s.add_runtime_dependency 'git', '>= 0'
end
