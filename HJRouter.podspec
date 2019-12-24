#
# Be sure to run `pod lib lint HJRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HJRouter'
  s.version          = '1.0'
  s.summary          = 'HJRouter'
  s.description      = <<-DESC
    ios router manage!
                       DESC

  s.homepage         = 'https://github.com/hanjun/HJRouter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hanjun' => '1017819339@qq.com' }
  s.source           = { :git => 'https://github.com/hanjun/HJRouter.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'HJRouter/Classes/**/*'
 
end
