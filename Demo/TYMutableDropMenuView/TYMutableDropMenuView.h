//
//  MutableDropMenuView.h
//  Demo
//
//  Created by gaga on 2017/8/12.
//  Copyright © 2017年 gaga. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYMutableDropMenuView;

//数据源方法
@protocol TYMutableDropMenuViewDateSource <NSObject>

@optional
-(NSInteger)numberOfSectionofMutableDropMenuView:(TYMutableDropMenuView *)view;//返回下拉菜单的种类数量，默认为1
-(CGFloat)fontofMutableDropMenuView:(TYMutableDropMenuView *)view;//返回字体大小,默认14
//以下两个方法至少实现一个
-(NSString *)mutableDropMenuView:(TYMutableDropMenuView *)view titleOfIndex:(NSInteger)index;//设置按钮组头的Title
-(UIView *)mutableDropMenuView:(TYMutableDropMenuView *)view headerViewofIndex:(NSInteger)index;//自定义组头视图
//使用上面mutableDropMenuView: headerViewofIndex:时此方法无效
-(UIImage *)mutableDropMenuView:(TYMutableDropMenuView *)view imageofheaderButtoninIndex:(NSInteger)index;//设置组头按钮的图片(文字左，图片右)

//必须实现的方法
@required
-(NSArray *)mutableDropMenuView:(TYMutableDropMenuView *)view dataArrayinSection:(NSInteger)section;

@end

//代理方法
@protocol TYMutableDropMenuViewDelegate <NSObject>

-(void)mutableDropMenuView:(TYMutableDropMenuView *)view didselected:(NSString *)result inColumn:(NSInteger)colume andIndexPath:(NSIndexPath *)indexPath;

@end

@interface TYMutableDropMenuView : UIView
-(instancetype)initWithFrame:(CGRect)frame inControllerView:(UIView *)mainView;//初始化方法，需传入控制器的view
@property (nonatomic,weak) id<TYMutableDropMenuViewDateSource> dataSource;
@property (nonatomic,weak) id<TYMutableDropMenuViewDelegate> delegate;
@end
