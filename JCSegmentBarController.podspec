#
# Be sure to run `pod lib lint JCSegmentBarController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JCSegmentBarController"
  s.version          = "0.0.1"
  s.summary          = "A short description of JCSegmentBarController."
  s.homepage         = "http://lijingcheng.github.io/"
  s.license          = 'MIT'
  s.author           = { "lijingcheng" => "bj_lijingcheng@163.com" }
  s.source           = { :git => "https://github.com/lijingcheng/JCSegmentBarController.git", :tag => s.version.to_s }
  s.social_media_url = 'http://weibo.com/lijingcheng1984'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'JCSegmentBarController' => ['Pod/Assets/*.png']
  }
end