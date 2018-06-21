//
//  SaveContact.h
//  SaveContact
//
//  Created by 沈红榜 on 2018/6/19.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveContact : NSObject


/**
 保存联系人到本地通讯录

 @param name 姓名
 @param phoneNumbers 手机号
 */
+ (void)saveContactWithName:(NSString *)name phoneNumbers:(NSArray <NSString *>*)phoneNumbers;

@end
