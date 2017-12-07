//
//  HYMediator+ContactsModule.h
//  MediatorDemo
//
//  Created by 沈红榜 on 2017/12/5.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import "HYMediator.h"

@interface HYMediator (ContactsModule)

- (void)HYMediator_applyForPermission:(void(^)(BOOL granted, NSError *error))handler;
- (NSArray <NSDictionary *>*)HYMediator_fetchAllLocalContacts;
- (void)HYMediator_contactsDidChanged:(dispatch_block_t)handler;

@end
