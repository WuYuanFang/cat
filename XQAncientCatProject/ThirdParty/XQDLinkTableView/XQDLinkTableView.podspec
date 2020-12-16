Pod::Spec.new do |s|

s.name         = "XQDLinkTableView"      #SDK名称
s.version      = "0.1"#版本号
s.homepage     = "https://github.com/SyKingW/XQProjectTool"  #工程主页地址
s.summary      = "一些项目里面要用到的’小公举’."  #项目的简单描述
s.license     = "MIT"  #协议类型
s.author       = { "王兴乾" => "1034439685@qq.com" } #作者及联系方式

s.ios.deployment_target = "9.3"#iPhone

s.source       = { :svn => "https://github.com/SyKingW/XQProjectTool", :tag => "#{s.version}"}   #工程地址及版本号

s.swift_version = '5'

s.source_files = 'SourceCode/**/*.{swift}'
# s.resources = 'XQFBaseSource/SDK/**/*.{xcassets}'
#s.resources = 'XQFBaseSource/SDK/**/*.{xib,bundle,png,jpg,jpeg,xcassets,strings,caf,mp3,xml,json,zip}'

s.dependency 'Masonry'
s.dependency 'MJRefresh'




end
