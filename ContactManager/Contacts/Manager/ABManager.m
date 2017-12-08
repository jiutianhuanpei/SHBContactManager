//
//  ABManager.m
//  MediatorDemo
//
//  Created by 沈红榜 on 2017/12/6.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import "ABManager.h"
#import <AddressBook/AddressBook.h>
#import "ContactsModel.h"
#import "ContactsTools.h"

@interface ABManager ()

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@property (nonatomic, assign) ABAuthorizationStatus status;
@property (nonatomic, assign) ABAddressBookRef      addressBook;
#pragma clang diagnostic pop

- (void)_addressBookDidChanged;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
void _AddressBookChange(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
    
    [[ABManager sharedInstance] _addressBookDidChanged];
    
}
#pragma clang diagnostic pop


@implementation ABManager

+ (instancetype)sharedInstance {
    static ABManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ABManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _addressBook = ABAddressBookCreate();
        
        ABAddressBookRegisterExternalChangeCallback(_addressBook, _AddressBookChange, nil);
        
#pragma clang diagnostic pop
    }
    return self;
}

- (void)applyForPermission:(void(^)(BOOL granted, NSError * _Nullable error))handler {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    _status = ABAddressBookGetAuthorizationStatus();
    if (_status != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            if (handler) {
                handler(granted, (__bridge NSError *)error);
            }
        });
    }
#pragma clang diagnostic pop
}

- (void)_addressBookDidChanged {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    _addressBook = ABAddressBookCreate();
#pragma clang diagnostic pop
    if (_contactsDidChanged) {
        _contactsDidChanged();
    }
}

- (NSArray<NSDictionary *> *)fetchAllContacts {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    CFArrayRef allPerson = ABAddressBookCopyArrayOfAllPeople(_addressBook);
    
    CFIndex num = ABAddressBookGetPersonCount(_addressBook);
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    
    for (CFIndex i = 0; i < num; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(allPerson, i);
        ContactsModel *model = SHBDealWithContact([self _modelFromContact:person]);
        if (model) {
            [dataArray addObject:model];
        }        
    }
#pragma clang diagnostic pop

    NSArray *aa = [dataArray valueForKeyPath:@"dicFromModel"];
    
    return aa;
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (ContactsModel *)_modelFromContact:(ABRecordRef)person {
    ContactsModel *model = [[ContactsModel alloc] init];
    
    
    model.identifier = [NSString stringWithFormat:@"%d", ABRecordGetRecordID(person)];
    model.name = CFBridgingRelease(ABRecordCopyCompositeName(person));
    model.imageData = CFBridgingRelease(ABPersonCopyImageData(person));
    
    CFNumberRef numberRef = ABRecordCopyValue(person, kABPersonKindProperty);
    
    if (numberRef == kABPersonKindPerson) {
        model.type = ContactTypePerson;
    } else if (numberRef == kABPersonKindOrganization) {
        model.type = ContactTypeOrganization;
    }
    
    if (numberRef) {
        CFRelease(numberRef);
    }
    
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phoneCount = ABMultiValueGetCount(phoneNumbers);
    
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    
    for (CFIndex i = 0; i < phoneCount; i++) {
        NSString *phone = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
        [phones addObject:phone];
    }
    
    model.phoneNumbers = phones;
    return model;
}
#pragma clang diagnostic pop


@end



