//
//  MutableDropMenuView.m
//  Demo
//
//  Created by gaga on 2017/8/12.
//  Copyright © 2017年 gaga. All rights reserved.
//

#import "TYMutableDropMenuView.h"
#import "TYMutableDropMenuCell.h"

@interface TYMutableDropMenuView ()<TYMutableDropMenuCellDelegate>

@property(nonatomic, strong)NSMutableArray *buttons;

@property(nonatomic, strong)NSMutableArray *items;

@property (nonatomic,weak)UIView *mainView;

@end


NSInteger _sectionCount = 1;//组数
CGFloat _font = 14;//字体大小

@implementation TYMutableDropMenuView
#pragma mark ====================
#pragma mark 初始化方法
-(instancetype)initWithFrame:(CGRect)frame inControllerView:(UIView *)mainView{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    _buttons = [NSMutableArray array];
    _items = [NSMutableArray array];
    _mainView = mainView;
    return self;
}
#pragma mark ====================
#pragma mark 设置数据源
-(void)setDataSource:(id<TYMutableDropMenuViewDateSource>)dataSource{
    _dataSource = dataSource;
    if([_dataSource respondsToSelector:@selector(numberOfSectionofMutableDropMenuView:)]){
        _sectionCount = [_dataSource numberOfSectionofMutableDropMenuView:self];
    }
    if([_dataSource  respondsToSelector:@selector(fontofMutableDropMenuView:)]){
        _font = [_dataSource fontofMutableDropMenuView:self];
    }
    [self setupHeaderView];
    
    [self renderTableViewdata];
}
#pragma mark ====================
#pragma mark 设置多级菜单的头视图
-(void)setupHeaderView{
    CGFloat buttonWidth = (self.frame.size.width - _sectionCount - 1) / _sectionCount; //计算每个按钮的宽度
    for(NSInteger i = 0; i < _sectionCount ; i++){
        CGFloat X = i * (buttonWidth + 1);
        CGFloat buttonHeight = self.frame.size.height;
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeaderView:)];
        if([_dataSource respondsToSelector:@selector(mutableDropMenuView:headerViewofIndex:)]){
            UIView *button = [_dataSource mutableDropMenuView:self headerViewofIndex:i];
            button.frame = CGRectMake(X, 0, buttonWidth, buttonHeight);
            [button addGestureRecognizer:gr];
            button.tag = i;
            [_buttons addObject:button];
            [self addSubview:button];
        }else{
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(X, 0, buttonWidth, buttonHeight)];
            NSString *title = [_dataSource mutableDropMenuView:self titleOfIndex:i];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
            button.titleLabel.font =  [UIFont systemFontOfSize:14];
            button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            if([_dataSource respondsToSelector:@selector(mutableDropMenuView:imageofheaderButtoninIndex:)]){
                UIImage *image = [_dataSource mutableDropMenuView:self imageofheaderButtoninIndex:i];
                [button setImage:image forState:UIControlStateNormal];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.bounds.size.width + 2, 0, button.imageView.bounds.size.width + 10)];
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width + 10, 0, -button.titleLabel.bounds.size.width + 2)];
            }
            [button addGestureRecognizer:gr];
            button.tag = i;
            [_buttons addObject:button];
            [self addSubview:button];
        }
        if(i < _sectionCount - 1){
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(X + buttonWidth,0,1,buttonHeight)];
            line.backgroundColor = [UIColor blackColor];
            [self addSubview:line];
        }
    }
}
#pragma mark ====================
#pragma mark headerview的点击事件
-(void)clickHeaderView:(UITapGestureRecognizer *)gr{
    NSInteger index = gr.view.tag;
    if(![_dataSource respondsToSelector:@selector(mutableDropMenuView:headerViewofIndex:)]){
        for (NSInteger i = 0; i < _sectionCount; i ++) {
            UIButton *button = _buttons[i];
            TYMutableDropMenuCell *cell = _items[i];
            if(button.tag == index){
                [button setSelected:YES];
                [cell setHidden:NO];
            }else{
                [button setSelected:NO];
                [cell setHidden:YES];
            }
        }
    }
}
#pragma mark ====================
#pragma mark 设置每一组的数据
-(void)renderTableViewdata{
    for (NSInteger i = 0; i < _sectionCount; i ++) {
        NSArray *data = [_dataSource mutableDropMenuView:self dataArrayinSection:i];
        TYMutableDropMenuCell *cell = [[TYMutableDropMenuCell alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width,250) andDataArray:data];
        cell.delegate = self;
        cell.tag = i;
        [self.mainView addSubview:cell];
        [_items addObject:cell];
        [cell setHidden:YES];
    }
}


#pragma mark ====================
#pragma mark 设置代理
-(void)setDelegate:(id<TYMutableDropMenuViewDelegate>)delegate{
    _delegate = delegate;
}
#pragma mark ====================
#pragma mark 每次选择后的代理
-(void)TYMutableDropMenuCell:(TYMutableDropMenuCell *)cell didselected:(NSString *)result inIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = cell.tag;
    UIButton *button = _buttons[index];
    [button setTitle:result forState:UIControlStateNormal];
    if([_delegate respondsToSelector:@selector(mutableDropMenuView:didselected:inColumn:andIndexPath:)]){
        [_delegate mutableDropMenuView:self didselected:result inColumn:index andIndexPath:indexPath];
    }
}



@end
