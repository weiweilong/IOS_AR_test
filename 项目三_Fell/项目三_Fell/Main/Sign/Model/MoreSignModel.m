//
//  MoreSignModel.m
//  项目三_Fell
//
//  Created by imac on 15/11/9.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "MoreSignModel.h"
#import "OwnerModel.h"
#import "NSDate+TimeAgo.h"

@implementation MoreSignModel

- (void)setAttributes:(NSDictionary *)dataDic{
    [super setAttributes:dataDic];
    
    self.signID = dataDic[@"id"];
    
    NSDictionary *card = dataDic[@"creator"];
    if(card != nil){
        OwnerModel *ownerModel = [[OwnerModel alloc] initWithDataDic:card];
        self.creator = ownerModel;
    }
    
    NSNumber *timeSince = dataDic[@"created"];
    // 格式化时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeSince integerValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    //        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *timeString = [date timeAgoWithLimit:24*60*60 dateFormatter:dateFormatter];
    self.created = timeString;
    
}

@end
