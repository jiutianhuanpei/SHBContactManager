//
//  HYMediator.m
//  HYGeneralMediator
//
//  Created by xuxue on 16/10/24.
//  Copyright © 2016年 xuxue. All rights reserved.
//

#import "HYMediator.h"

@implementation HYMediator

+ (instancetype)sharedInstance
{
    static HYMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[HYMediator alloc]init];
    });
    return mediator;
}

/*
 URL[scheme://host/path?query]
 host->target
 path->action
 query->params
*/
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *resultInfo))completion
{
    if(![[url scheme] isEqualToString:@"theAppScheme"])
    {
        return @(NO);
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSString *paramStr = [url query];
    for(NSString *param in [paramStr componentsSeparatedByString:@"&"])
    {
        NSArray *paramKeyValue = [param componentsSeparatedByString:@"="];
        if([paramKeyValue count]<2)
            continue;
        [params setObject:[paramKeyValue lastObject] forKey:[paramKeyValue firstObject]];
    }
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    id result = [self performTarget:url.host action:actionName params:params];
    if(completion)
    {
        if(result)
            completion(@{@"result":result});
        else
            completion(nil);
    }
    return result;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params
{
    NSString *targetClassStr = [NSString stringWithFormat:@"Target_%@",targetName];
    NSString *actionStr = nil;
    
    if (params != nil)
    {
        actionStr = [NSString stringWithFormat:@"Action_%@:",actionName];
    }
    else
    {
        actionStr = [NSString stringWithFormat:@"Action_%@",actionName];
    }
    
    Class targetClass = NSClassFromString(targetClassStr);
    id target = [[targetClass alloc]init];
    SEL action = NSSelectorFromString(actionStr);
    if(target == nil)
    {
        return nil;
    }
    if([target respondsToSelector:action])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        return [target performSelector:action withObject:params];
        
#pragma clang diagnostic pop
    }else
    {
        //无响应请求时，调用默认notFound方法
        SEL action = NSSelectorFromString(@"notFound:");
        if([target respondsToSelector:action])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            return [target performSelector:action withObject:params];
            
#pragma clang diagnostic pop
        }else
        {
            //notFound方法也无响应时，可以做一些弹窗操作
            return nil;
        }
    }
}

@end
