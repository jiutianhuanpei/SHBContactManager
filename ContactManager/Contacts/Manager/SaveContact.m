//
//  SaveContact.m
//  TestDemo
//
//  Created by 沈红榜 on 2018/6/19.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "SaveContact.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

@interface SaveContact ()

@end

@implementation SaveContact


+ (void)saveContactWithName:(NSString *)name phoneNumbers:(NSArray <NSString *>*)phoneNumbers {
    
    if (@available(iOS 9.0, *)) {
        [self ios9_fetchGranted:^{
            [self ios9_saveContactWithName:name phoneNumbers:phoneNumbers];
        }];
    } else {
        [self ios8_fetchGranted:^{
            [self ios8_saveContactWithName:name phoneNumbers:phoneNumbers];
        }];
    }
}

#pragma mark - 获取权限
+ (void)ios9_fetchGranted:(dispatch_block_t)callback API_AVAILABLE(ios(9.0)) {
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (status == CNAuthorizationStatusAuthorized) {
        callback();
    } else {
        [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                callback();
            }
        }];
    }
}

+ (void)ios8_fetchGranted:(dispatch_block_t)callback {
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusAuthorized) {
        callback();
    } else {
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                callback();
            }
        });
    }
}


#pragma mark - 保存数据
+ (void)ios9_saveContactWithName:(NSString *)name phoneNumbers:(NSArray <NSString *>*)phoneNumbers API_AVAILABLE(ios(9.0)) {
    
    
    //电话本
    CNContactStore *store = [[CNContactStore alloc] init];
    
    //构建电话
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (NSString *num in phoneNumbers) {
        
        CNPhoneNumber *number = [CNPhoneNumber phoneNumberWithStringValue:num];
        CNLabeledValue *value = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:number];
        [phones addObject:value];
    }
    

    //查询是否存在联系人
    NSPredicate *predicate = [CNContact predicateForContactsMatchingName:name];
    NSArray <CNContact *>*array = [store unifiedContactsMatchingPredicate:predicate keysToFetch:@[CNContactPhoneNumbersKey, CNContactGivenNameKey] error:nil];
    
    
    if (array.count == 0) {
        CNMutableContact *contact = [[CNMutableContact alloc] init];
        contact.givenName = name;
        
        contact.phoneNumbers = phones;
        
        CNSaveRequest *request = [[CNSaveRequest alloc] init];
        [request addContact:contact toContainerWithIdentifier:nil];

        [store executeSaveRequest:request error:nil];
        
    } else {
        
        CNMutableContact *contact = [array.firstObject mutableCopy];
        contact.givenName = name;
        contact.phoneNumbers = phones;
        
        CNSaveRequest *request = [[CNSaveRequest alloc] init];
        [request updateContact:contact];
        
        [store executeSaveRequest:request error:nil];
        
    }
}

+ (void)ios8_saveContactWithName:(NSString *)name phoneNumbers:(NSArray <NSString *>*)phoneNumbers {
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    //fetch contact with name
    CFArrayRef persons = ABAddressBookCopyPeopleWithName(addressBook, CFBridgingRetain(name));
    
    //remove old contact data
    for (CFIndex i = 0; i < CFArrayGetCount(persons); i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(persons, i);
        ABAddressBookRemoveRecord(addressBook, person, NULL);
        CFRelease(person);
    }
    
    //create new contact
    ABRecordRef contact = ABPersonCreate();
    
    //set value
    ABRecordSetValue(contact, kABPersonFirstNameProperty, CFBridgingRetain(name), NULL);
    
    //phoneNumber is multi
    ABMultiValueRef phones = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    for (NSString *phoneStr in phoneNumbers) {

        ABMultiValueAddValueAndLabel(phones, CFBridgingRetain(phoneStr), kABPersonPhoneMobileLabel, NULL);
    }
    
    ABRecordSetValue(contact, kABPersonPhoneProperty, phones, NULL);
    
    //add contact to addressBook
    ABAddressBookAddRecord(addressBook, contact, NULL);
    
    
    //save
    ABAddressBookSave(addressBook, NULL);
    
    //release
    CFRelease(contact);
    CFRelease(addressBook);
}


@end
