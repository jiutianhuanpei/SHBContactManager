//
//  ABManager.h
//  MediatorDemo
//
//  Created by 沈红榜 on 2017/12/6.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABManager : NSObject

+ (instancetype _Nullable )sharedInstance;

@property (nonatomic, copy) dispatch_block_t _Nullable contactsDidChanged;

- (void)applyForPermission:(void(^_Nullable)(BOOL granted, NSError * _Nullable error))handler;

- (NSArray <NSDictionary *>*_Nullable)fetchAllContacts;

@end
