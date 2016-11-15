Pod::Spec.new do |s|
  s.name         = "TFPhotoBrowser"
  s.version      = "0.2.4"
  s.summary      = "时光流影iOS照片浏览框架"
  s.homepage     = "https://github.com/TimeFaceCoder/TFPhotoBrowser"
  s.license      = "Copyright (C) 2015 TimeFace, Inc.  All rights reserved."
  s.author             = { "Melvin" => "yangmin@timeface.cn" }
  s.social_media_url   = "http://www.timeface.cn"
  s.ios.deployment_target = "7.1"
  s.source       = { :git => "https://github.com/TimeFaceCoder/TFPhotoBrowser.git"}
  s.source_files  = "TFPhotoBrowser/TFPhotoBrowser/**/*.{h,m,c}"
  s.resource = ['TFPhotoBrowser/TFPhotoBrowser/Resources/TFLibraryResource.bundle','TFPhotoBrowser/TFPhotoBrowser/Resources/TFPhotoBrowserLocalizations.bundle']
  s.frameworks = 'ImageIO', 'QuartzCore', 'AssetsLibrary', 'MediaPlayer'
  s.weak_frameworks = 'Photos'
  s.requires_arc = true
  s.dependency 'pop'
  s.dependency 'SDWebImage'
  s.dependency 'PINRemoteImage', '3.0.0-beta.6'
  s.dependency 'AFNetworking'
  s.dependency 'DACircularProgress'
  s.dependency 'SVProgressHUD'
end
