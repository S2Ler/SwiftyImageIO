Pod::Spec.new do |s|
  s.name             = "SwiftyImageIO"
  s.version          = "0.3.0"
  s.summary          = "A swift wrapper around ImageIO framework"
  s.description      = <<-DESC
  Provides an easy interface to ImageIO framework.
                       DESC
  s.homepage         = "https://github.com/diejmon/SwiftyImageIO"
  s.license          = 'MIT'
  s.author           = { "Alexander Belyavskiy" => "diejmon@gmail.com" }
  s.source           = { :git => "https://github.com/diejmon/SwiftyImageIO.git", :tag => s.version.to_s }
  s.platforms        = { :ios => "8.0", :osx => "10.9", :tvos => "9.0" }
  s.requires_arc     = true
  s.source_files     = 'Sources/**/*'
  s.frameworks       = 'Foundation', 'ImageIO'
end
