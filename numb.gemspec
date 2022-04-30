
Gem::Specification.new do |s|
  s.name = 'numb'
  s.version = '0.0.1'
  s.date = '2022-04-30'
  s.summary = "non-unified mapper B"
  s.authors = ["xxanon"]
  s.email = "ironald@gmail.com"
  s.files = `git ls-files`.split("\n") - %w[bin misc]
  s.executables += `git ls-files bin`.split("\n").map{|e| File.basename(e)}
  s.homepage = "https://github.com/nonnax/numb.git"
  s.license = "GPL-3.0"
end

