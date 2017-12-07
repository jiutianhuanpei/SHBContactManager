//
//  ContactsModel.m
//  MediatorDemo
//
//  Created by 沈红榜 on 2017/12/5.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import "ContactsModel.h"

@implementation ContactsModel

- (NSString *)phone {
    return _phoneNumbers.firstObject;
}

- (NSDictionary *)dicFromModel {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"identifier"] = _identifier;
    dic[@"name"] = _name;
    dic[@"imageData"] = _imageData;
    dic[@"type"] = @(_type);
    dic[@"phoneNumbers"] = _phoneNumbers;
    dic[@"phone"] = self.phone;
    return dic;
}

- (NSString *)stringByReplaceUnicode:(NSString *)unicodeString {
    NSMutableString *convertedString = [unicodeString mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    
    return convertedString;
}



@end
