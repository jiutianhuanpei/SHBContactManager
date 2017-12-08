//
//  Target_Contacts.h
//  MediatorDemo
//
//  Created by 沈红榜 on 2017/12/5.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_Contacts : NSObject

- (id)Action_applyForPermission:(NSDictionary *)param;
- (id)Action_fetchAllLocalContacts;
- (id)Action_contactsDidChanged:(NSDictionary *)param;
@end
