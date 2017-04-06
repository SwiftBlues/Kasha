Pod::Spec.new do |s|
  s.name        = "Kasha"
  s.version     = "0.1.0"
  s.summary     = "A JSON API library for Swift."
  s.description = <<-DESC
  If you have to work with JSON API, but don’t like reflections, this library is for you.
  DESC

  s.homepage = "https://github.com/SwiftBlues/Kasha"
  s.license  = "Apache License, Version 2.0"
  s.author   = "Alexander Tovstonozhenko"

  s.ios.deployment_target     = "9.0"
  s.osx.deployment_target     = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target    = "9.0"

  s.source       = { :git => "https://github.com/SwiftBlues/Kasha.git", :tag => "#{s.version}" }
  s.source_files = "Sources/**/*"

  s.dependency "Marshal", "~> 1.2"
end

