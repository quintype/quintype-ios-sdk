Pod::Spec.new do |spec|
  spec.name = "Quintype"
  spec.version = "1.0.0"
  spec.summary = "Framework for using Quintype core product."
  spec.homepage = "https://github.com/quintype/ios-core-sdk"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Albin CR" => 'albinzr@gmail.com' }


  spec.platform = :ios, "10.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/quintype/ios-core-sdk.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "Quintype/**/*.{h,swift}"

  spec.dependency "Curry", "~> 1.4.0"
end
