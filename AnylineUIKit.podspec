#
#  Be sure to run `pod spec lint AnylineUIKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "AnylineUIKit"
  spec.version      = "0.0.3"
  spec.summary      = "The AnylineUIKit is an additional UI component for the Anyline OCR SDK"
  spec.description  = "Anyline - https://www.anyline.com - is a mobile OCR SDK, which can be customized to scan all kinds of numbers, characters, text and codes. The Anyline UIKit Framework is an additional UI component for the Anyline SDK product."

  spec.homepage     = "https://github.com/Anyline/anyline-uikit-framework"
  spec.license      = "https://github.com/Anyline/anyline-uikit-framework/license.md"
  spec.author       = { "Anyline GmbH" => "support@anyline.com" }
  spec.platform     = :ios, "12.0"
  spec.swift_version = '4.2'

  # spec.source       = { :http => "https://github.com/Anyline/anyline-uikit-framework" }
  spec.source       = { :git => "https://github.com/Anyline/anyline-uikit-framework.git" }

  # spec.source       = { :path => '.' }

  spec.resources = ["AnylineUIKit/Resources/**/*.{xib,storyboard,xcassets,strings,json}"]
  spec.dependency 'Anyline', '>= 25'
  spec.dependency 'SnapKit', '~> 5.0'
  spec.dependency 'OpenCV'
  spec.static_framework = true

  spec.source_files  = "AnylineUIKit/**/*.{h,m,mm,pch,swift}"
  spec.exclude_files = "Classes/Exclude"
  spec.swift_version = "4.2"

end
