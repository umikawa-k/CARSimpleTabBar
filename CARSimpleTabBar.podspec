Pod::Spec.new do |s|
  s.name         = "CARSimpleTabBar"
  s.version      = "0.9"
  s.summary      = ""
  s.homepage     = "https://github.com/CrayonApps/CARSimpleTabBar"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "CrayonApps inc." => "hello@crayonapps.com" }
  s.source       = { :git => 'https://github.com/CrayonApps/CARSimpleTabBar.git', :tag => "v#{s.version}" }
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.source_files = 'CARSimpleTabBar/CARSimpleTabBar.{h,m}'
  s.requires_arc = true
end
