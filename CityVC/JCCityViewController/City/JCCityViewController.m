//
//  JCCityViewController.m
//  JCCityViewController
//
//  Created by wang on 16/8/10.
//  Copyright © 2016年 wang. All rights reserved.
//
#define kScreenWidth                    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                   [UIScreen mainScreen].bounds.size.height
#define krect(x, y, w, h) CGRectMake(x, y, w, h)
#define Font(x)   [UIFont systemFontOfSize:x]        //设置系统字体

#import "JCCityViewController.h"

@interface JCCityViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *mainTable;
    NSString * locationCity;
    NSArray *hotCity;
    UIView *hdview;
    
    NSString *golablCity;
    
    UILabel *centerLabel;
}
@property (nonatomic,strong) NSMutableArray * dataSource, * dataBase, *allData;

@end
@implementation JCCityViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    
    self.title = @"城市";
    hotCity = @[@"上海",@"北京",@"广州",@"深圳",@"武汉",@"天津",@"西安",@"南京",@"杭州",@"成都",@"重庆"];
    mainTable.tableHeaderView = [self gettableHdView];
    [self initdata];

}
-(void)initdata{
    //改变索引的颜色
    mainTable.sectionIndexColor = [UIColor orangeColor];
    //改变索引选中的背景颜色
    mainTable.sectionIndexTrackingBackgroundColor = [UIColor whiteColor];
    //索引数组
    _dataSource = [[NSMutableArray alloc] init] ;
    //tableview 数据源
    _allData = [[NSMutableArray alloc]init];
    
    //初始化数据
    NSString *lowStr;
    NSArray *titArr;
    for(char c = 'A'; c <= 'Z'; c++ )
    {
        [_dataSource addObject:[NSString stringWithFormat:@"%c",c]];
        //
        lowStr = [[NSString stringWithFormat:@"%c",c] lowercaseString];
        titArr =  [self getCityByCharWord:lowStr];
        _dataBase = [[NSMutableArray alloc] init] ;
        
        for (NSDictionary *city in titArr) {
            [_dataBase addObject:city[@"name"]];
        }
        [_allData addObject:_dataBase];
    }
    
}
-(UIView *)gettableHdView{
    hdview = [[UIView alloc]initWithFrame:krect(0, 0, kScreenWidth, 260)];
    hdview.backgroundColor = [UIColor lightGrayColor];
    UILabel *firstTitle = [[UILabel alloc]initWithFrame:krect(10, 5, kScreenWidth, 15)];
        locationCity = @"深圳";
    firstTitle.text = @"当前定位:";
    firstTitle.font = Font(14);
    firstTitle.textColor = [UIColor blackColor];
    [hdview addSubview:firstTitle];
    float kbtnWidth;
    kbtnWidth = (kScreenWidth - 40-20)/3;
    UIButton *locationBtn = [[UIButton alloc]initWithFrame:krect(10, 30, kbtnWidth, 30)];
    locationBtn.backgroundColor = [UIColor orangeColor];
    [locationBtn setTitle:locationCity forState:0];
    locationBtn.layer.cornerRadius = 5;
    locationBtn.tag = 9;
    locationBtn.titleLabel.font = Font(17);
    [locationBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [hdview addSubview:locationBtn];
    
    UILabel *secondTitle = [[UILabel alloc]initWithFrame:krect(10, 70, kScreenWidth - 10, 15)];
    secondTitle.text = @"热门城市";
    secondTitle.font = Font(14);
    secondTitle.textColor = [UIColor blackColor];
    [hdview addSubview:secondTitle];
    
    for (int i = 0; i<11; i++) {
        UIButton *hotBtn = [[UIButton alloc]initWithFrame:krect(10 + i%3*(kbtnWidth +10), 95 + i/3*40, kbtnWidth, 30)];
        hotBtn.backgroundColor = [UIColor whiteColor];
        [hotBtn setTitleColor:[UIColor blackColor] forState:0];
        [hotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [hotBtn setBackgroundImage:[UIImage imageNamed:@"org"] forState:UIControlStateHighlighted];
        [hotBtn setTitle:hotCity[i] forState:0];
        hotBtn.titleLabel.font = Font(17);
        hotBtn.layer.cornerRadius = 5;
        hotBtn.layer.masksToBounds = YES;
        hotBtn.tag = 10 + i;
        [hotBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [hdview addSubview:hotBtn];
        
    }
    
    return hdview;
}
-(void)clickBtn:(UIButton *)btn{
    if (btn.tag == 9) {
        golablCity = locationCity;
    }else{
        golablCity = hotCity[btn.tag - 10];
    }
    if (_callBlock) {
        _callBlock(golablCity);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - table
//26个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataSource count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _allData[section];
    return arr.count;
}
//
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _dataSource;
}
//
//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [_dataSource objectAtIndex:section];
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSInteger count = 0;
    
    NSLog(@"%@-%ld",title,(long)index);
    
    for(NSString *character in _dataSource)
    {
        if([character isEqualToString:title])
        {
            
            if (!centerLabel) {
                centerLabel = [[UILabel alloc]initWithFrame:krect(kScreenWidth/2 - 20, kScreenHeight/2 -40, 40, 40)];
                centerLabel.text = title;
                centerLabel.layer.borderWidth = 1;
                centerLabel.layer.borderColor = [UIColor greenColor].CGColor;
                centerLabel.textColor = [UIColor orangeColor];
                centerLabel.textAlignment = NSTextAlignmentCenter;
                centerLabel.font = [UIFont boldSystemFontOfSize:20];
                [self.view addSubview:centerLabel];
                [self performSelector:@selector(HidCenterLabel) withObject:self afterDelay:2];
            }else{
                centerLabel.text = title;
                [centerLabel setHidden:NO];
                [self performSelector:@selector(HidCenterLabel) withObject:self afterDelay:2];
            }
            
            
            return count;
        }
        count ++;
    }
    return 0;
    
}
-(void)HidCenterLabel{
    [centerLabel setHidden:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = _allData[indexPath.section][indexPath.row];
    cell.textLabel.font = Font(17);
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    golablCity = _allData[indexPath.section][indexPath.row];
    if (_callBlock) {
        _callBlock(golablCity);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    
    //取消选中的cell
    NSArray * indexPaths = [mainTable indexPathsForSelectedRows];
    
    for(NSIndexPath * indexPath in indexPaths)
    {
        [mainTable deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


#pragma mark - 传一个字母进来，拿到这个字母对应的城市
- (NSArray *) getCityByCharWord:(NSString *)word{
    NSMutableArray *passArray = @[].mutableCopy;
    NSString *addressPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"按拼音排列.json"];
    
    NSData *data = [NSData dataWithContentsOfFile:addressPath];
    //data转字符串
    NSString *str = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    //字符串转字典
    NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    NSDictionary *tempDic;
    NSString *pyStr;
    NSString *tempstr;
    NSArray *allCity = [returnDic objectForKey:@"allcity"];
    for (int i = 0 ; i<allCity.count; i++) {
        tempDic = allCity[i];
        pyStr = tempDic[@"pinyin"];
        tempstr = [pyStr substringToIndex:1];
        //        NSLog(@"%@",tempstr);
        if ([tempstr isEqualToString:word]) {
            [passArray addObject:tempDic];
        }
    }
    NSArray *apppp = [NSArray arrayWithArray:passArray];
    return apppp;
}

@end
