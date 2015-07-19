Pod::Spec.new do |s|

  s.name             = "LMDropdownView"
  s.version          = "1.0.2"
  s.summary          = "LMDropdownView is a simple dropdown view inspired by Tappy"
  s.homepage         = "https://github.com/lminhtm/LMDropdownView"
  s.license          = 'MIT'
  s.author           = { "LMinh" => "lminhtm@gmail.com" }
  s.source           = { :git => "https://github.com/lminhtm/LMDropdownView.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'LMDropdownView/**/*.{h,m}'

end
