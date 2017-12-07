//
//  ContactsManager.m
//  MediatorDemo
//
//  Created by 沈红榜 on 2017/12/5.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import "CNManager.h"
#import <Contacts/Contacts.h>
#import "ContactsTools.h"
#import "ContactsModel.h"

@interface CNManager ()

@property (nonatomic, strong) CNContactStore    *store;
@property (nonatomic, assign) CNAuthorizationStatus status;

@end

@implementation CNManager

+ (instancetype)sharedInstance {
    static CNManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CNManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _store = [[CNContactStore alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactsDidChanged:) name:CNContactStoreDidChangeNotification object:nil];
    }
    return self;
}


- (void)contactsDidChanged:(NSNotification *)noti {
    _store = [[CNContactStore alloc] init];
    if (_contactsDidChanged) {
        _contactsDidChanged();
    }
}

- (void)applyForPermission:(void(^)(BOOL granted, NSError * _Nullable error))handler {
    _status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (_status != CNAuthorizationStatusAuthorized) {
        [_store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (handler) {
                handler(granted, error);
            }
        }];
    }
}

- (NSArray <NSDictionary *>*_Nullable)fetchAllContacts {
    if (_status != CNAuthorizationStatusAuthorized) {
        return @[];
    }
    
    NSError *error = nil;
    __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactIdentifierKey,
                                                                                          CNContactGivenNameKey,
                                                                                          CNContactFamilyNameKey,
                                                                                          CNContactImageDataKey,
                                                                                          CNContactTypeKey,
                                                                                          CNContactPhoneNumbersKey
                                                                                          ]];
    [_store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        ContactsModel *model = SHBDealWithContact([self _modelFromContact:contact]);
        
        if (model) {
            [array addObject:model];
        }
    }];
    
    NSArray *aa = [array valueForKeyPath:@"dicFromModel"];
    return aa;
}

- (ContactsModel *)_modelFromContact:(CNContact *)contact {
    ContactsModel *model = [[ContactsModel alloc] init];
    model.identifier = contact.identifier;
    model.name = [contact.familyName stringByAppendingString:contact.givenName];
    model.imageData = contact.imageData;
    
    if (contact.contactType == CNContactTypePerson) {
        model.type = ContactTypePerson;
    } else if (contact.contactType == CNContactTypeOrganization) {
        model.type = ContactTypeOrganization;
    }
    
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (CNLabeledValue *labeldValue in contact.phoneNumbers) {
        CNPhoneNumber *number = labeldValue.value;
        [phones addObject:number.stringValue];
    }
    model.phoneNumbers = phones;
    return model;
}


@end
