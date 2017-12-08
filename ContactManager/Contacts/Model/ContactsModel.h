//
//  ContactsModel.h
//  MediatorDemo
//
//  Created by 沈红榜 on 2017/12/5.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ContactType) {
    ContactTypePerson,
    ContactTypeOrganization,
};

@interface ContactsModel : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, assign) ContactType type;
@property (nonatomic, strong) NSArray <NSString *>*phoneNumbers;
@property (nonatomic, copy, readonly) NSString *phone;

- (NSDictionary *)dicFromModel;

@end
