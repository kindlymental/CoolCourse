platform :ios, '8.0'

project 'CoolCourse.xcodeproj'

use_frameworks!
inhibit_all_warnings!

target 'CoolCourse' do
    pod 'Masonry'
    pod 'YYWebImage', '~> 1.0.5'   # 支持SDWebImage的大部分功能且添加了新特性和性能提升
    pod 'ReactiveObjC', '~> 1.0.1'
    pod 'AFNetworking', '~> 3.1.0'
    pod 'Protobuf', '~> 3.2.0'  #  Google 公司内部的混合语言数据标准，是一种轻便高效的结构化数据存储格式，可以用于结构化数据串行化，或者说序列化
    pod 'CocoaAsyncSocket', '~> 7.6.0'
    pod 'Qiniu', '~> 7.1.5'    # 七牛云存储
    pod 'UICKeyChainStore', '~> 2.1.1'   # 用于存储token
    pod 'TZImagePickerController'   # 支持多选、选原图和视频的图片选择器，有预览和裁剪功能，同样经常使用的还有CTAssetsPickerController
    pod 'SVProgressHUD'
    pod 'DateTools', '~> 2.0.0'   # 简化时间和日期处理的很牛逼的工具库，友好化时间
    pod 'MLEmojiLabel', '~> 1.0.2'  # 自动识别网址、号码、邮箱、@、#话题#和表情的label
    pod 'MJRefresh', '~> 3.1.12'

    #data
    pod 'YYModel'
    pod 'YYCategories','1.0.4'
    pod 'FMDB', '~> 2.6.2'
    pod 'FMDBMigrationManager', '~> 1.4.1'  # FMDB的转换工具，支持SQLite数据库迁移，与FMDB结合使用，可以记录数据库版本号并对数据库进行数据库升级等操作
    pod 'MTLFMDBAdapter', '~> 0.3.2'  # MTLFMDBAdapter需要 Mantle作为依赖项
    
    #检测内存溢出
    pod 'MLeaksFinder','1.0.0'
    #日志框架
    pod 'CocoaLumberjack','3.4.2'
    #无数据提示
    pod 'DZNEmptyDataSet','1.8.1'
end
