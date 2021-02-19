#
#  Be sure to run `pod spec lint AnylineUIKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "AnylineUIKit"
  spec.version      = "0.0.2"
  spec.summary      = "A short description of AnylineUIKit."
  spec.description  = "Description of AnylineUIKit."

  spec.homepage     = "http://EXAMPLE/AnylineUIKit"
  spec.license      = "MIT"
  spec.author             = { "Anastasiya Markovets" => "anastasiya.markovets@9y.co" }
  spec.platform     = :ios, "12.0"
  spec.swift_version = '4.0'

  spec.source       = { :path => '.' }
  spec.resources = ["AnylineUIKit/Resources/**/*.{xib,storyboard,xcassets,strings,json}"]
  spec.dependency 'Anyline', '~> 25'
  spec.dependency 'SnapKit', '~> 5.0'
  spec.dependency 'OpenCV'
  spec.static_framework = true

  spec.source_files  = "AnylineUIKit/**/*.{h,m,mm,pch,swift}"
  spec.exclude_files = "Classes/Exclude"
  spec.swift_version = "4.2"

end
