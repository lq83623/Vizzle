  
//
//  BXTWTripListModel.m
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-07-14 21:28:18 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//



#import "BXTWTripListModel.h"
#import "BXTWTripListItem.h"

@interface BXTWTripListModel()

@end

@implementation BXTWTripListModel

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods
- (NSDictionary *)dataParams {
    
    return @{@"country":@"TW",
             @"uid":@"",
             @"start":[NSString stringWithFormat:@"%ld",(long)self.currentPageIndex*self.pageSize],
             @"size":@"10",
             @"lat":@"",
             @"lng":@""};
}

- (NSInteger)pageSize
{
    return 10;
}

- (VZHTTPRequestConfig)requestConfig
{
    VZHTTPRequestConfig config = vz_defaultHTTPRequestConfig();
    config.requestMethod = VZHTTPMethodPOST;
    config.cachePolicy = VZHTTPNetworkURLCachePolicyDefault;
    return config;
}

- (NSString* )cacheKey
{
    return [[[self methodName] stringByAppendingString:@"/"]stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)self.currentPageIndex]];
}

- (NSString *)methodName {
    
    return @"http://42.121.16.186:9999/baseservice/getRecommendList";
}


- (NSMutableArray* )responseObjects:(id)JSON
{

    NSMutableArray* list = [NSMutableArray new];
    NSArray* result = JSON[@"result"][@"lists"];
    
    int i=0;
    int topl = 0;
    int topr = 0;
    int w = [UIScreen mainScreen].bounds.size.width/2 ;
    for (NSDictionary* dict in result) {
        
        BXTWTripListItem* item =  [BXTWTripListItem new];
        item.itemWidth  = w;
        item.itemHeight = [self randomHeight];
        
        item.x = i%2 * w ;
        
        //left
        if (i%2 == 0)
        {
            item.y = topl;
            topl += item.itemHeight;
        }
        //right
        else
        {
            item.y = topr;
            topr += item.itemHeight;
        }
        

        [item autoKVCBinding:dict];
        [list addObject:item];
        i ++;
    }
    
    _contentHeight = MAX(topl, topr);

    return list;
}


- (CGFloat)randomHeight
{
    int value = arc4random() % 100 + 160;
    return value;
}

@end

