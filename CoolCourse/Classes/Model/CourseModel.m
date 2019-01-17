//
//  CourseModel.m
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/13.
//  Copyright © 2019 lyl. All rights reserved.
//

#import "CourseModel.h"

@implementation CourseModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"courseId" : @"id"};
}

@end
