

Pod::Spec.new do |spec|
  spec.name = "Quintype"
  spec.version = "1.0.0"
  spec.summary = "Sample framework from blog post, not for real world use."
  spec.homepage = "https://github.com/Albinzr/Quintype"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Albin CR" => 'your-albinzr@gmail.com' }
  spec.social_media_url = "http://twitter.com/thoughtbot"

  spec.platform = :ios, "9.1"
  spec.requires_arc = true
  spec.source = { :git => "https://github.com/Albinzr/Quintype.git", submodules: true }
  spec.source_files = "CoreiOS/**/*.{h,swift}"

  spec.dependency "Curry", "~> 1.4.0"
end