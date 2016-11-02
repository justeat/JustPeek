#
# Be sure to run `pod lib lint JustPeek.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JustPeek'
  s.version          = '0.3.0'
  s.summary          = 'iOS Library that adds support for Force Touch-like Peek and Pop interactions on older devices'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
JustPeek is an iOS Library that adds support for Force Touch-like Peek and Pop interactions on devices that do not natively support it due to lack of force recognition in the screen.
Under the hood it uses the native implementation if available, otherwise a custom implementation based on UILongPressGestureRecognizer.
                       DESC

  s.homepage         = 'https://github.com/justeat/JustPeek'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = 'Just Eat'
  s.source           = { :git => 'https://github.com/justeat/JustPeek.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/justeat_tech'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JustPeek/Classes/**/*'
  s.frameworks = 'UIKit'
end
