Pod::Spec.new do |s|
  s.name             = "TPLSService"
  s.version          = "0.1.0"
  s.summary          = "Third Party Login & Share Service SDK"

  s.description      = <<-DESC
                        Third Party Login & Share Service SDK
                       DESC

  s.homepage         = "http://github.com/islate/TPLSService"
  s.license          = 'Apache 2.0'
  s.author           = { "林溢泽" => "linyize@gmail.com" }
  s.source           = { :git => "http://github.com/islate/TPLSService.git", :tag => "#{s.version}" }

  s.ios.deployment_target = '8.0'
  s.source_files = "TPLSService/*.{h,m}"

  s.dependency "SinaWeibo-Slate"
  s.dependency "WeChat-Slate"
  s.dependency "QQ-Slate"
  s.dependency "AVOSCloud"
end