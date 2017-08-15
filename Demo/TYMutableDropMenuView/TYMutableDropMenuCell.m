//
//  TYMutableDropMenuCell.m
//  Demo
//
//  Created by gaga on 2017/8/14.
//  Copyright © 2017年 gaga. All rights reserved.
//

#import "TYMutableDropMenuCell.h"


@interface TYMutableDropMenuCell ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NSArray *dataArray;

@property (nonatomic, strong)NSMutableArray *tableViews;

@property (nonatomic,assign)NSInteger dataDeep;

@end

@implementation TYMutableDropMenuCell

-(instancetype)initWithFrame:(CGRect)frame andDataArray:(NSArray *)dataArray{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    if(dataArray != nil){
        _dataDeep = 1;
        _dataArray = [self analysisData:dataArray];
        _tableViews = [NSMutableArray array];
        [self setupView];
    }
    return self;
}
#pragma mark ====================
#pragma mark 解析数据结构，重新构造dataArray
-(NSArray *)analysisData:(NSArray *)data{
    NSMutableArray *newdata = [NSMutableArray array];
    for(NSInteger i = 0; i < data.count; i++){
        if([data[i] isKindOfClass:[NSString class]]){
            [newdata addObject:data[i]];
        }else{
            NSDictionary *dict = data[i];
            NSMutableDictionary *tydict = [NSMutableDictionary dictionary];
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if([obj isKindOfClass:[NSArray class]]){
                    [tydict setValue:[self analysisData:obj] forKey:@"sub"];
                }else{
                    [tydict setValue:obj forKey:@"name"];
                }
            }];
            [newdata addObject:tydict];
        }
    }
    return newdata;
}
#pragma mark ====================
#pragma mark 搭建界面
-(void)setupView{
    NSArray *data = _dataArray;
    while([data[0] isKindOfClass:[NSDictionary class]] && [data[0] objectForKey:@"sub"] != nil) {
        _dataDeep ++;
        data = data[0][@"sub"];
    }
    data = _dataArray;
    CGFloat width = self.frame.size.width / _dataDeep;
    CGRect frame = self.frame;
    frame.size.width = width;
    for(NSInteger i = 0; i<_dataDeep; i++){
        frame.origin.x = i * width;
        UITableView *tableView = [[UITableView alloc]initWithFrame:frame];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.showsVerticalScrollIndicator = NO;
        [_tableViews addObject:tableView];
        [self addSubview:tableView];
    }
    [_tableViews[0] selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
/**0x00007f929f038c00
 0x00007f929f03c200
 0x00007f929f040600
 0x00007f929f042200
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *data = _dataArray;
    NSInteger count = 0;
    for(NSInteger i =0 ; i< _dataDeep ; i++){
        UITableView *_tableView = _tableViews[i];
        if(_tableView == tableView){
            count = data.count;
            break;
        }
        data = data[[_tableView indexPathForSelectedRow].row][@"sub"];
    }
    
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"TYMutableDropMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSInteger i = 0;
    NSArray *data = _dataArray;
    for (; i< _dataDeep; i ++) {
        UITableView *_tableView = _tableViews[i];
        if(_tableView == tableView){
            break;
        }
    }
    for(NSInteger j=0;j<i;j++){
        UITableView *tableView = _tableViews[j];
        NSInteger index = 0;
        if(tableView.indexPathForSelectedRow.row > 0){
            index = tableView.indexPathForSelectedRow.row;
        }
        data = data[index][@"sub"];
    }
    if([data[indexPath.row] isKindOfClass:[NSString class]]){
        cell.textLabel.text = data[indexPath.row];
    }else{
        cell.textLabel.text = data[indexPath.row][@"name"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger i = 0;
    NSArray *data = _dataArray;
    for (; i< _dataDeep; i ++) {
        UITableView *_tableView = _tableViews[i];
        if(_tableView == tableView){
            break;
        }
        data = data[_tableView.indexPathForSelectedRow.row][@"sub"];
    }
    NSString *result = [NSString string];
    if([data[indexPath.row] isKindOfClass:[NSString class]]){
        result = data[indexPath.row];
    }else{
        result = data[indexPath.row][@"name"];
    }
    if(i < _dataDeep - 1){
        UITableView *tableView = _tableViews[i+1];
        tableView.tag = [data[indexPath.row][@"sub"] count];
        for (NSInteger j = i + 1; j < _dataDeep; j ++) {
            UITableView *tableView = _tableViews[j];
            [tableView reloadData];

        }
    }
    
    if([self.delegate respondsToSelector:@selector(TYMutableDropMenuCell:didselected:inIndexPath:)]){
        [self.delegate TYMutableDropMenuCell:self didselected:result inIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:i]];
    }
}















@end
