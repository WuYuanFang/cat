
Pod::Spec.new do |s|
    s.name         = 'JFCitySelector'
    s.version      = '0.0.1'
    s.summary      = 'wxq'
    s.homepage     = 'https://github.com/zhifenx/JFCitySelector'
    s.license      = 'MIT'
    s.authors      = {'wxq' => '1034439685@qq.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/CrabMen/CMPageTitleView.git', :tag => s.version}
    s.requires_arc = true

    s.source_files = 'JFCitySelector/**/*.{h,m}'
    s.resources = 'JFCitySelector/**/*.{sqlite,json}'
    
    s.ios.dependency 'Masonry'
    s.ios.dependency 'FMDB'
    s.ios.dependency 'YYModel'
    
    

end
