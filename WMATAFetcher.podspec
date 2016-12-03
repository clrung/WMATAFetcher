Pod::Spec.new do |s|
  s.name	      = 'WMATAFetcher'
  s.version          = '2.2.0'
  s.summary          = 'Wrapper Pod for the WMATA API'

  s.description      = <<-DESC
WMATAFetcher contains helper methods to fetch predictions from the WMATA API.
It uses [SwiftyJSON](https://cocoapods.org/pods/SwiftyJSON) to populate an array of [Train](http://cocoadocs.org/docsets/WMATAFetcher/1.0.1/Classes/Train.html) objects, which contain the number of cars, destination, group, line, location, and minutes until train arrival.
                       DESC

  s.homepage	      = 'https://github.com/clrung/WMATAFetcher'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Christopher Rung' => 'clrung@gmail.com' }
  s.source           = { :git => 'https://github.com/clrung/WMATAFetcher.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/clrung'

  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.9'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'WMATAFetcher/**/*.swift'

  s.dependency 'SwiftyJSON', '~> 3.0'
end
