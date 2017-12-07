//
//  Target_Contacts.m
//  MediatorDemo
//
//  Created by 沈红榜 on 2017/12/5.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import "Target_Contacts.h"
#import "CNManager.h"
#import "ABManager.h"

@implementation Target_Contacts

- (id)Action_applyForPermission:(NSDictionary *)param {
    
    if (@available(iOS 9.0, *)) {
        [[CNManager sharedInstance] applyForPermission:param[@"handler"]];
    } else {
        [[ABManager sharedInstance] applyForPermission:param[@"handler"]];
    }
    
    return nil;
}

- (id)Action_fetchAllLocalContacts {
    
    NSArray *array = nil;
    if (@available(iOS 9.0, *)) {
        array = [[CNManager sharedInstance] fetchAllContacts];
    } else {
        array = [[ABManager sharedInstance] fetchAllContacts];
    }
    
    return array;
}

- (id)Action_contactsDidChanged:(NSDictionary *)param {
    if (@available(iOS 9.0, *)) {
        [CNManager sharedInstance].contactsDidChanged = param[@"handler"];
    } else {
        [ABManager sharedInstance].contactsDidChanged = param[@"handler"];
    }
    
    return nil;
}

@end
