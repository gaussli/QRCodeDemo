//
//  MacroDefinition.h
//  Project
//
//  Created by lijinhai on 12/8/14.
//  Copyright (c) 2014 JH. All rights reserved.
//

#ifndef Project_MacroDefinition_h
#define Project_MacroDefinition_h

// 导入必要的类

// 设备大小常量
#define JH_DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width            // 屏幕宽度
#define JH_DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height          // 屏幕高度
#define JH_TABBAR_HEIGHT 49                                                // TabBar高度
#define JH_STATUSBAR_HEIGHT 20                                             // 状态栏高度
#define JH_NAVBAR_HEIGHT  44                                               // NavigationBar高度

#define JH_DEVICE_SYSTEM_VERSION [[UIDevice currentDevice].systemVersion doubleValue]   //获得系统版本

// 应用常量
#define JH_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0]   // 设置颜色

// NSUserDefaults
#define JH_USERDEFAULTS [NSUserDefaults standardUserDefaults]

// 关于文件管理的常量
#define JH_FILE_MANAGER [NSFileManager defaultManager]                                             // 文件管理者

#define JH_SANDBOX_DOCUMENTS_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]    // sandbox中documents文件夹路径

#define JH_SANDBOX_LOG_DERECTORY [JH_SANDBOX_DOCUMENTS_PATH stringByAppendingPathComponent:@"log"]     // 日志缓存路径

#endif
