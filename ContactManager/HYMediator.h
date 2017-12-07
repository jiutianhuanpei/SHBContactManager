//
//  HYMediator.h
//  HYGeneralMediator
//
//  Created by xuxue on 16/10/24.
//  Copyright © 2016年 xuxue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYMediator : NSObject

+ (instancetype)sharedInstance;

/**
 远程APP调用入口

 @param url        NSURL
 @param completion block回调

 @return id
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *resultInfo))completion;

/**
 本地组件调用入口

 @param targetName target名
 @param actionName action名
 @param params     参数

 @return id
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params;
                                                   
@end
