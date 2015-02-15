
Pod::Spec.new do |s|
  s.name         = "LTNavigationbar"
  s.version      = "0.1.0"
  s.summary      = "UINavigationBar Category which allows you to change its background dynamically"
  s.homepage     = "https://github.com/ltebean/LTNavigationbar"
  s.license      = "MIT"
  s.author       = { "ltebean" => "yucong1118@gmail.com" }
  s.source       = { :git => "https://github.com/ltebean/LTNavigationbar.git", :tag => 'v0.1.0'}
  s.source_files = "LTNavigationbar/LTNavigationbar.{h,m}"
  s.requires_arc = true
  s.platform     = :ios, '7.0'

end
