//
//  VideoPlayViewCell.m
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/10.
//  Copyright © 2019 lyl. All rights reserved.
//

#import "VideoPlayViewCell.h"

@interface VideoPlayViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation VideoPlayViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 10;
}

- (void)setModel:(CourseModel *)model {
    _model = model;
    
    [self.imgView yy_setImageWithURL:[NSURL URLWithString:model.onpic] placeholder:[UIImage imageNamed:@"video_play_default"]];
    self.titleLabel.text = model.name;
    self.detailLabel.text = model.intro;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
