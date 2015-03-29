/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */


#import "ChatListCell.h"
#import "AvatarView.h"

@interface ChatListCell (){
    UILabel *_timeLabel;
    UILabel *_unreadLabel;
    UILabel *_detailLabel;
    UIView *_lineView;
}

@end

@implementation ChatListCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 7, 80, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
        
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(289, 27, 20, 20)];
        _unreadLabel.backgroundColor = [UIColor orangeColor];
        _unreadLabel.textColor = [UIColor whiteColor];
        
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.layer.cornerRadius = 10;
        _unreadLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, 175, 20)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = [UIColor colorWithWhite:0.710 alpha:1.000];
        [self.contentView addSubview:_detailLabel];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        

        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(10, 7, 45, 45)];
        _avatarView.userInteractionEnabled = YES;
        [_avatarView setConers];
        _avatarView.delegate = self;
        [self.contentView addSubview:_avatarView];

        //_lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 1)];
         //_lineView.backgroundColor = [UIColor colorWithWhite:0.766 alpha:1.000];
        //[self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor colorWithRed:0.961 green:0.345 blue:0.063 alpha:1.000];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor orangeColor];
    }
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    CGRect frame = self.imageView.frame;
    
    [self.avatarView setURL:[self.imageURL absoluteString] defaultImage:@"chatListCellHead" type:1];
    
   /* if (self.imageURL) {
        
        [self.avatarView setURL:self.imageURL fillType:UIImageResizeFillTypeFillIn options:WTURLImageViewOptionAnimateEvenCache placeholderImage:_placeholderImage failedImage:_placeholderImage diskCacheTimeoutInterval:100 * 24 * 60 * 60 * 1000];
        
    }else {
        
        self.avatarView.image = _placeholderImage;
    }*/
    //[self.imageView setImage:_placeholderImage];
    //self.imageView.frame = CGRectMake(10, 7, 45, 45);
    self.textLabel.textColor = [UIColor colorWithRed:0.278 green:0.216 blue:0.188 alpha:1.000];
    self.textLabel.text = _name;
    self.textLabel.frame = CGRectMake(65, 7, 175, 20);
    
    _detailLabel.text = _detailMsg;
    _timeLabel.text = _time;
    if (_unreadCount > 0) {
        if (_unreadCount < 9) {
            _unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            _unreadLabel.font = [UIFont systemFontOfSize:12];
        }else{
            _unreadLabel.font = [UIFont systemFontOfSize:10];
        }
        [_unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = [NSString stringWithFormat:@"%d",_unreadCount];
    }else{
        [_unreadLabel setHidden:YES];
    }
    
    frame = _lineView.frame;
    frame.origin.y = self.contentView.frame.size.height - 1;
    _lineView.frame = frame;
}

-(void)setName:(NSString *)name{
    _name = name;
    self.textLabel.text = name;
}

+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
#pragma mark - WTUrlImageViewDelegate

- (void) URLImageViewDidClicked : (WTURLImageView*)imageView {
    
    if (self.cdelegate && [self.cdelegate respondsToSelector:@selector(chatCell:DidClickAvatarWithIndexRow:)]) {
        
        [self.cdelegate chatCell:self DidClickAvatarWithIndexRow:self.indexRow];
    }
}

@end
