Pod::Spec.new do |s|
  s.name         = "SHBContactManager"
  s.version      = "0.0.4"
  s.summary      = "本地通讯录读取模块"
  s.description  = <<-DESC
    读取本地通讯录，组件化封装，并区分 iOS9 以上或以下api，需要 xCode 9 以上打开。
                   DESC
  s.homepage     = "https://github.com/jiutianhuanpei/SHBContactManager"
  s.license      = "MIT"
  s.author             = { "shenhongbang" => "shenhongbang@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/jiutianhuanpei/SHBContactManager.git", :tag => s.version }
  s.source_files  = "ContactManager/**/*"
  s.frameworks = "AddressBook", "Contacts"
  s.resources = ["QuickMarkModule/Image/*.png"]
  s.dependency  'HYMediator'
  s.xcconfig = {
    'USER_HEADER_SEARCH_PATHS' => '$(inherited) $(SRCROOT)/HYMediator'
  }
  s.requires_arc = true
end