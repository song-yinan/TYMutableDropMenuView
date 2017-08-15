//
//  TYMutableDropMenuCell.h
//  Demo
//
//  Created by gaga on 2017/8/14.
//  Copyright © 2017年 gaga. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYMutableDropMenuCell;

@protocol TYMutableDropMenuCellDelegate <NSObject>

-(void)TYMutableDropMenuCell:(TYMutableDropMenuCell *)cell didselected:(NSString *)result inIndexPath:(NSIndexPath *)indexPath;

@end

@interface TYMutableDropMenuCell : UIView

-(instancetype)initWithFrame:(CGRect)frame andDataArray:(NSArray *)dataArray;

@property (nonatomic,weak) id<TYMutableDropMenuCellDelegate> delegate;

@end
