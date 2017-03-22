Pod::Spec.new do |s|
  s.name             = "Fluxer"
  s.version          = "1.0.0"
  s.summary          = "Swift Flux Micro Framework"

  s.homepage         = "https://github.com/rb-de0/Fluxer"
  s.license          = 'MIT'
  s.author           = { "rb_de0" => "rebirth.de0@gmail.com" }
  s.source           = { :git => "https://github.com/rb-de0/Fluxer.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/rb_de0'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Sources/**/*.swift'
end
