Pod::Spec.new do |s|
  s.name	      = 'WMATAFetcher'
  s.version          = '1.0.0'
  s.summary          = 'Wrapper Pod for the WMATA API'

  s.description      = <<-DESC
Helper methods to fetch predictions from the WMATA API.
                       DESC

  s.homepage	      = 'https://github.com/clrung/WMATAFetcher'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Christopher Rung' => 'christopher.rung@gmail.com' }
  s.source           = { :git => 'https://github.com/clrung/WMATAFetcher.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/clrung'

  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.9'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'WMATAFetcher/**/*.swift'

  s.dependency 'SwiftyJSON', '~> 2.3'
end
