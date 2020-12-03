

Pod::Spec.new do |spec|

  spec.name         = "RNWebSDK"
  spec.version      = "1.0.0"
  spec.summary      = "RNWebSDK to demonstrate the native and JS communication."
  spec.description  = <<-DESC
                    This framwework to demonstrate the native iOS and JS communication related to Camera and Video recording feature.
                   DESC

  spec.homepage     = "https://github.com/zac24/RNWebSDK"
  spec.license      = "MIT"
  spec.author       = { "Prashant Dwivedi" => "dwi.pra24@gmail.com" }
  spec.swift_version = "5.0"
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/zac24/RNWebSDK.git", :tag => "#{spec.version}" }
  spec.source_files  = "RNWebSDK/**/*.{h,m,swift}"
  #spec.resources = "RNWebSDK/**/*.{xib}"

end
