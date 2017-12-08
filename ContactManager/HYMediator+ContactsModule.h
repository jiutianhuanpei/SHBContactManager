//
//  HYMediator+ContactsModule.h
//  MediatorDemo
//
//  Created by 沈红榜 on 2017/12/5.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#if __has_include(<HYMediator/HYMediator.h>)
#import <HYMediator/HYMediator.h>
#else
#import "HYMediator.h"
#endif


@interface HYMediator (ContactsModule)


/**
 请求读取通讯录权限

 @param handler 回调
 */
- (void)HYMediator_applyForPermission:(void(^)(BOOL granted, NSError *error))handler;

/**
 读取所有的，符合规则的成员
 其手机号符合 1[0-9]{10}，

 @return 联系人数组
 */
- (NSArray <NSDictionary *>*)HYMediator_fetchAllLocalContacts;

/**
 当通讯录有改变时的通知回调

 @param handler 回调
 */
- (void)HYMediator_contactsDidChanged:(dispatch_block_t)handler;

@end
