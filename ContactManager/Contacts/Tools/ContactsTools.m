//
//  ContactsTools.m
//  MediatorDemo
//
//  Created by 沈红榜 on 2017/12/7.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import "ContactsTools.h"

NSString *_phoneNumberWithStr(NSString *num) {
    
    num = [num stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@" " withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@"-" withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@"(" withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"self matches %@", @"1[0-9]{10}"];
    if ([pre evaluateWithObject:num]) {
        return num;
    }

    return nil;
}

ContactsModel *SHBDealWithContact(ContactsModel *model) {
    
    NSMutableSet *set = [NSMutableSet setWithCapacity:0];
    
    for (NSString *num in model.phoneNumbers) {
        
        NSString *phoneNumber = _phoneNumberWithStr(num);
        if (phoneNumber) {
            [set addObject:phoneNumber];
        }
    }
    
    if (set.count > 0) {
        model.phoneNumbers = set.allObjects;
        return model;
    }
    
    return nil;
}
