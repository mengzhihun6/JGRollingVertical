//
//  JGRollTableVerticalCell.m
//  JGRollingVertical
//
//  Created by 郭军 on 2019/5/6.
//  Copyright © 2019 ZYWL. All rights reserved.
//

#import "JGRollTableVerticalCell.h"

@implementation JGRollTableVerticalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _TitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        _TitleLbl.textColor = JG333Color;
        _TitleLbl.font = JGFont(16);
        _TitleLbl.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_TitleLbl];
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
