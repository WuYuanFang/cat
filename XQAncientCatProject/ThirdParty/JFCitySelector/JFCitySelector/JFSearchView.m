//
//  JFSearchView.m
//  JFFootball
//
//  Created by 张志峰 on 2016/11/24.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "JFSearchView.h"

static NSString *ID = @"searchCell";

@interface JFSearchView ()<UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JFSearchView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
}

- (void)setResultMutableArray:(NSMutableArray <XQ_JFAreaDataModel *> *)resultMutableArray {
    _resultMutableArray = resultMutableArray;
    [self.tableView reloadData];
}

//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.backgroundColor = [UIColor clearColor];
//    }
//    return _tableView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_resultMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    XQ_JFAreaDataModel *dataDic = _resultMutableArray[indexPath.row];
    NSString *text = @"";
    if (dataDic.area_name.length == 0) {
        text = [NSString stringWithFormat:@"%@，%@", dataDic.province_name, dataDic.city_name];
    }else {
        text = [NSString stringWithFormat:@"%@，%@，%@", dataDic.province_name, dataDic.city_name, dataDic.area_name];
    }
    
    
    cell.textLabel.text = text;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XQ_JFAreaDataModel *model = _resultMutableArray[indexPath.row];
    if (![model.city_name isEqualToString:@"抱歉"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchResults:)]) {
            [self.delegate searchResults:model];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchViewToExit)]) {
        [self.delegate touchViewToExit];
    }

}
@end
