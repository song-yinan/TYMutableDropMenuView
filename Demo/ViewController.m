//
//  ViewController.m
//  Demo
//
//  Created by gaga on 2017/8/12.
//  Copyright © 2017年 gaga. All rights reserved.
//

#import "ViewController.h"
#import "TYMutableDropMenuView.h"

@interface ViewController ()<TYMutableDropMenuViewDateSource,TYMutableDropMenuViewDelegate>

@property (nonatomic, strong) NSArray *addressArr;
@property (nonatomic, strong) NSArray *sortsArr;
@property (nonatomic, strong) NSArray *typeArr;

@end

@implementation ViewController

-(NSArray *)addressArr{
    if (_addressArr == nil) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address.plist" ofType:nil]];
        _addressArr = dic[@"address"];
    }
    return _addressArr;
}

-(NSArray *)sortsArr{
    if (_sortsArr == nil) {
        _sortsArr =  [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sorts.plist" ofType:nil]];
    }
    return _sortsArr;
}

-(NSArray *)typeArr{
    if (_typeArr == nil) {
        _typeArr =  [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"type.plist" ofType:nil]];
    }
    return _typeArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TYMutableDropMenuView *view = [[TYMutableDropMenuView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 20) inControllerView:self.view];
    view.dataSource = self;
    view.delegate = self;
    [self.view addSubview:view];
}
//列数
-(NSInteger)numberOfSectionofMutableDropMenuView:(TYMutableDropMenuView *)view{
    return 3;
}
//每列的标题
-(NSString *)mutableDropMenuView:(TYMutableDropMenuView *)view titleOfIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"第%ld列",index];
}
//每列的数据（传入数组）
-(NSArray *)mutableDropMenuView:(TYMutableDropMenuView *)view dataArrayinSection:(NSInteger)section{
    if(section == 0){
        return self.addressArr;
    }else if(section == 1){
        return self.sortsArr;
    }else if(section ==2){
        return self.typeArr;
    }else{
        return self.typeArr;
    }
}
//获取选择的值
-(void)mutableDropMenuView:(TYMutableDropMenuView *)view didselected:(NSString *)result inColumn:(NSInteger)colume andIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"<---%ld---->列选择了<----%@------>在<-----%@------>",colume,result,indexPath);
}

@end
