//
//  CourseModel.h
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/13.
//  Copyright © 2019 lyl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CourseModel : NSObject

@property (nonatomic , copy) NSString              * courseId;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * tag;
@property (nonatomic , copy) NSString              * intro;
@property (nonatomic , copy) NSString              * onpic;   // 图片
@property (nonatomic , copy) NSString              * gid;
@property (nonatomic , copy) NSString              * tid;
@property (nonatomic , copy) NSString              * cid;
@property (nonatomic , copy) NSString              * grade;
@property (nonatomic , copy) NSString              * sort;
@property (nonatomic , copy) NSString              * stime;
@property (nonatomic , copy) NSString              * etime;
@property (nonatomic , copy) NSString              * vurl;
@property (nonatomic , copy) NSString              * burl;   // 视频
@property (nonatomic , assign) NSInteger              isbuy;

@end

