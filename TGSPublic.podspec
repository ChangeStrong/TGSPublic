#
# Be sure to run `pod lib lint TGSPublic.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TGSPublic'
  s.version          = '0.1.0'
  s.summary          = 'A short description of TGSPublic.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ChangeStrong/TGSPublic'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ChangeStrong' => '491337430@qq.com' }
  s.source           = { :git => 'https://github.com/ChangeStrong/TGSPublic.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'TGSPublic/Classes/**/*.{h,m,mm,swift}'
  
  # s.resource_bundles = {
  #   'TGSPublic' => ['TGSPublic/Assets/*.png']
  # }

   s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'MapKit', 'Foundation', 'AVFoundation', 'CommonCrypto', 'WebKit'
  # s.dependency 'AFNetworking', '~> 2.3'
   s.dependency 'Alamofire', '~> 5.0'
   s.dependency 'RxSwift', '~> 5'
   s.dependency 'RxCocoa', '~> 5'
   s.dependency 'Moya/RxSwift', '~> 14.0'
   s.dependency 'HandyJSON', '5.0.4-beta'
   #swift 数据库
   s.dependency 'GRDB.swift', '~> 5.24.0'
end
