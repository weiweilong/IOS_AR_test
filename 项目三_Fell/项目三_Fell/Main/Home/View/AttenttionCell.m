//
//  AttenttionCell.m
//  项目三_Fell
//
//  Created by imac on 15/11/1.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "AttenttionCell.h"
#import "AttentionModel.h"
#import "CardModel.h"
#import "CommentModel.h"
#import "OwnerModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+FDCollapsibleConstraints.h"
#import "NSDate+TimeAgo.h"

#define domain @"http://img01.feelapp.cc/"


@implementation AttenttionCell

- (void)awakeFromNib {
    [_attentionButton addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    _attentionButton.layer.masksToBounds = YES;
    _attentionButton.layer.cornerRadius = 10;

    [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    _shareButton.layer.masksToBounds = YES;
    _shareButton.layer.cornerRadius = 8;
    
    [_likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    _likeButton.layer.masksToBounds = YES;
    _likeButton.layer.cornerRadius = 8;
    
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = 20;
}

/*
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self _initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self _initView];
    }
    return self;
}

- (void)_initView{
    NSLog(@"%@", self.attentionModel);
}
*/

- (void)setAttentionModel:(AttentionModel *)attentionModel{
    _attentionModel = attentionModel;
    
    // 填充数据
    
    _nickLabel.text = _attentionModel.cardModel.ownerModel.nick;
    if(_attentionModel.actionTime.length == 0){
        _timeLabel.hidden = YES;
        _timeImageView.hidden = YES;
    }else{
        _timeLabel.text = _attentionModel.actionTime;
    }
    
    if(_attentionModel.cardModel.loc.length == 0){
        _locationLabel.hidden = YES;
        _locationImageView.hidden = YES;
    }else{
        _locationLabel.text = _attentionModel.cardModel.loc;
    }

//    NSString *picName = [[_attentionModel.cardModel.pics firstObject] objectForKey:@"uri"];
//    // http://img01.feelapp.cc/  cards/2015-11-2/Q/Q3QZFf.jpg
//    // 根据发帖的id来判断是否是官方的ID (id=2)，是 则要加上域名
//    // 还要根据type类型来判断，是card类型则要加上域名
//    if([_attentionModel.actorId integerValue] == 2){
//        ownerImageName = [NSString stringWithFormat:@"%@%@", domain , ownerImageName];
//    }
//    if([_attentionModel.actorId integerValue] == 2 && [_attentionModel.cardModel.type isEqualToString:@"card"]){
//        picName = [NSString stringWithFormat:@"%@%@", domain , picName];
//    }
    
    NSString *ownerImageName = _attentionModel.cardModel.ownerModel.avatar;
    [_userImageView setImageWithURL:[NSURL URLWithString:ownerImageName] placeholderImage:[UIImage imageNamed:@"goal_icon_type_photo36G@2x"]];
    
    // 判断是否有多张图片
    if(_attentionModel.cardModel.pics.count <= 1){
        _moreImageView.hidden = YES;
    }
    NSString *picName = [[_attentionModel.cardModel.pics firstObject]objectForKey:@"uri"];
    [_comtentImageView setImageWithURL:[NSURL URLWithString:picName] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];

    NSString *comtentString = _attentionModel.cardModel.desc;
//    comtentString = [comtentString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    comtentString = [comtentString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    _comtentLabel.text = comtentString;
    NSMutableString *tagName = [NSMutableString string];
    [_attentionModel.cardModel.tags enumerateObjectsUsingBlock:^(NSDictionary *tagDic, NSUInteger idx, BOOL *stop) {
        [tagName appendFormat:@"#%@  ", tagDic[@"bname"]];
    }];
    _tagLabel.text = tagName;
    if([_attentionModel.cardModel.comment_count longValue] <= 3){
        _allCommentLabel.hidden = YES;
        switch ([_attentionModel.cardModel.comment_count integerValue]) {
            case 0:
                _cmOneView.fd_collapsed = YES;
                _cmOneView.hidden = YES;
                _cmTwoView.fd_collapsed = YES;
                _cmTwoView.hidden = YES;
                _cmThreeView.fd_collapsed = YES;
                _cmThreeView.hidden = YES;
                _cmAllView.fd_collapsed = YES;
//                _commentImageView.fd_collapsed = YES;
                break;

            case 1:
            {
                CommentModel *oneCommentModel = [_attentionModel.cardModel.comments firstObject];
                _commentOneLabel.text = [NSString stringWithFormat:@"%@: “%@”",oneCommentModel.from_ownerModel.nick , oneCommentModel.content];
                _cmTwoView.hidden = YES;
                _cmThreeView.hidden = YES;
                _cmTwoView.fd_collapsed = YES;
                _cmThreeView.fd_collapsed = YES;
                _cmAllView.hidden = YES;
                _cmAllView.fd_collapsed = YES;
            }
                break;
                
            case 2:
            {
                CommentModel *oneCommentModel = [_attentionModel.cardModel.comments firstObject];
                _commentOneLabel.text = [NSString stringWithFormat:@"%@: “%@”",oneCommentModel.from_ownerModel.nick , oneCommentModel.content];
                CommentModel *twoCommentModel = _attentionModel.cardModel.comments[1];
                _commentTwoLabel.text = [NSString stringWithFormat:@"%@: “%@”",twoCommentModel.from_ownerModel.nick , twoCommentModel.content];
                
                _cmThreeView.hidden = YES;
                _cmThreeView.fd_collapsed = YES;
                _cmAllView.hidden = YES;
                _cmAllView.fd_collapsed = YES;
            }
                break;
                
            case 3:
                [self _reloadMoreComment];
                break;
                
            default:
//                _commentOneLabel.fd_collapsed = YES;
//                _commentTwoLabel.fd_collapsed = YES;
//                _commentThreeLabel.fd_collapsed = YES;
//                _commentImageView.fd_collapsed = YES;
                break;
        }
    }else{
        [self _reloadMoreComment];
        // 加载更多评论视图
        _allCommentLabel.text = [NSString stringWithFormat:@"查看 %ld 条评论",     [_attentionModel.cardModel.comment_count integerValue]];
    }
    
    // 点赞视图 7
    if(_attentionModel.cardModel.likeOwners.count >= 6){
        [self createLikeView:6];
    }else{
        [self createLikeView:_attentionModel.cardModel.likeOwners.count];
    }
    
    
}

- (void)createLikeView:(NSInteger)count{
#warning 添加点击事件
    // 给每个头像添加点击事件
    if(count == 0){
        _likeView.hidden = YES;
        _likeView.fd_collapsed = YES;
    }
    
    for(int i = 1; i<=count; i++){
        UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30 * i + i*5, 0, 30, 30)];
        likeImageView.layer.masksToBounds = YES;
        likeImageView.layer.cornerRadius = 15;
        OwnerModel *ownerModel = _attentionModel.cardModel.likeOwners[i-1];
        [likeImageView setImageWithURL:[NSURL URLWithString:ownerModel.avatar]];
        [_likeView addSubview:likeImageView];
    }
}
- (void)_reloadMoreComment{
    CommentModel *oneCommentModel = [_attentionModel.cardModel.comments firstObject];
    _commentOneLabel.text = [NSString stringWithFormat:@"%@: %@",oneCommentModel.from_ownerModel.nick , oneCommentModel.content];
    CommentModel *twoCommentModel = _attentionModel.cardModel.comments[1];
    _commentTwoLabel.text = [NSString stringWithFormat:@"%@: %@",twoCommentModel.from_ownerModel.nick , twoCommentModel.content];
    CommentModel *threeCommentModel = _attentionModel.cardModel.comments[2];
    _commentThreeLabel.text = [NSString stringWithFormat:@"%@: %@",threeCommentModel.from_ownerModel.nick , threeCommentModel.content];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 点击加载所有赞列表
- (IBAction)moreLikeButton:(id)sender {

}

#pragma mark 关注按钮点击
- (void)attentionAction:(UIButton *)button{
    
}

#pragma mark 分享按钮点击方法
- (void)shareAction:(UIButton *)button{
    
}

#pragma mark 点赞按钮点击方法
- (void)likeAction:(UIButton *)button{
    
}

@end
