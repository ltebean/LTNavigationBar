
Pod::Spec.new do |s|
  s.name         = "LTNavigationBar"
  s.version      = "1.0.1"
  s.summary      = "UINavigationBar Category which allows you to change its background dynamically"
  s.homepage     = "https://github.com/ltebean/LTNavigationbar"
  s.license      = "MIT"
  s.author       = { "ltebean" => "yucong1118@gmail.com" }
  s.source       = { :git => "https://github.com/ltebean/LTNavigationbar.git", :tag => 'v1.0.1'}
  s.source_files = "LTNavigationbar/UINavigationBar+BackgroundColor.{h,m}"
  s.requires_arc = true
  s.platform     = :ios, '7.0'

end
