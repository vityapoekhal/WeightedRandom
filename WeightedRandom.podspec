Pod::Spec.new do |s|

  s.name         = "WeightedRandom"
  s.version      = "1.0.0"
  s.summary      = "Randomly selects elements from an weighted array."

  s.description  = <<-DESC
                    Randomly selects elements from an weighted array.
                    Each element has a known probability of selection.
                   DESC

  s.homepage     = "http://github.com/victorhydecode/WeightedRandom"
  s.license      = "MIT"
  s.author             = { "Victor Hyde" => "veektahhoodeh@gmail.com" }

  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/victorhydecode/WeightedRandom.git", :tag => "#{s.version}" }
  s.source_files  = "WeightedRandom", "WeightedRandom/**/*.{h,m,swift}"
  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '4.0'
  }
end
