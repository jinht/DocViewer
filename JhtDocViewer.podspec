Pod::Spec.new do |s|
    
    s.name                       = 'JhtDocViewer'
    s.version                    = '1.0.3'
    s.summary                    = '文档/文件查看器（支持本地或者其他app分享过来的word、excel、pdf、rtf等格式文件）'
    s.homepage                   = 'https://github.com/jinht/DocViewer'
    s.license                    = { :type => 'MIT', :file => 'LICENSE' }
    s.author                     = { 'Jinht' => 'jinjob@icloud.com' }
    s.social_media_url           = 'https://blog.csdn.net/Anticipate91'
    s.platform                   = :ios
    s.ios.deployment_target      = '8.0'
    s.source                     = { :git => 'https://github.com/jinht/DocViewer.git', :tag => s.version }
    s.resource                   = 'JhtDocViewer_SDK/JhtDocViewer.bundle'
    s.ios.vendored_frameworks    = 'JhtDocViewer_SDK/JhtDocViewer.framework'
    s.frameworks                 = 'UIKit'
    s.dependency		 'AFNetworking'

end
