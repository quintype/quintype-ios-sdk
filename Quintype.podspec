Pod::Spec.new do |spec|
  spec.name = "Quintype"
  spec.version = "1.0.0"
  spec.summary = "Sample framework from blog post, not for real world use.Functional JSON parsing library for Swift."
  spec.homepage = "https://github.com/Albinzr/Quintype"
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors = {
    "Jake Craige" => 'james.craige@gmail.com',
    "thoughtbot" => nil,
  }
  spec.social_media_url = "http://twitter.com/thoughtbot"

  spec.source = { :git => "https://github.com/Albinzr/Quintype.git", :tag => "v#{spec.version}", :submodules => true }
  spec.source_files  ="CoreiOS/**/*.{h,swift}"
  spec.requires_arc = true
  spec.platform     = :ios
  spec.ios.deployment_target = "9.1"

  spec.dependency "Curry", '~> 1.4.0'
end