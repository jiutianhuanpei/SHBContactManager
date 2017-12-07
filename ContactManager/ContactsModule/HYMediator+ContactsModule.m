//
//  HYMediator+ContactsModule.m
//  MediatorDemo
//
//  Created by 沈红榜 on 2017/12/5.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import "HYMediator+ContactsModule.h"

NSString *const kTargetContacts = @"Contacts";

@implementation HYMediator (ContactsModule)

- (void)HYMediator_applyForPermission:(void (^)(BOOL, NSError *))handler {
    NSDictionary *param = @{@"handler" : handler};
    [self performTarget:kTargetContacts action:@"applyForPermission" params:param];
}

- (NSArray<NSDictionary *> *)HYMediator_fetchAllLocalContacts {
    return [self performTarget:kTargetContacts action:@"fetchAllLocalContacts" params:nil];
}

- (void)HYMediator_contactsDidChanged:(dispatch_block_t)handler {
    NSDictionary *param = @{@"handler" : handler};
    [self performTarget:kTargetContacts action:@"contactsDidChanged" params:param];
}

@end
