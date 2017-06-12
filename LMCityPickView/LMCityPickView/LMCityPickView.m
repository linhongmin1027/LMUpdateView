//
//  LMCityPickView.m
//  LHMLiveTV
//
//  Created by iOSDev on 17/5/31.
//  Copyright © 2017年 iOSDev. All rights reserved.
//

#import "LMCityPickView.h"
#import <Masonry.h>
#define PickContainViewHeight (250)
@interface LMCityPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
/**  选择器  */
@property(nonatomic, weak)UIPickerView *pickView;
/**  容器视图  */
@property(nonatomic, weak)UIView *containView;
/**  数据源数组  */
@property(nonatomic, copy)NSArray *dataArray;
/**  临时选择数组  */
@property(nonatomic, strong)NSMutableArray *selectedArray;
/**  省份数组  */
@property(nonatomic, strong)NSMutableArray *provinceArray;
/**  城市数组  */
@property(nonatomic, strong)NSMutableArray *cityArray;
/**  地区数组  */
@property(nonatomic, strong)NSMutableArray *areaArray;

@property(nonatomic, strong)NSMutableArray *zipcodeArray;

/**  省份  */
@property(nonatomic, copy)NSString *province;
/**  城市  */
@property(nonatomic, copy)NSString *city;
/**  地区  */
@property(nonatomic, copy)NSString *area;
/**  邮编  */
@property(nonatomic, copy)NSString *zipcode;

@property(nonatomic, copy)void(^selectedBlock)(NSString *,NSString *,NSString *,NSString*);
@end
static UIWindow *window_;
@implementation LMCityPickView
-(instancetype)init{
    self=[super init];
    if (self) {
        
        [self loadData];
        [self setupSubviews];
    }
    return self;
}

+(void)showWithSelectedBlock:(void(^)(NSString *province,NSString *ciry,NSString *area,NSString*zipcode))selectedBlock{
    window_=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window_.hidden=NO;
    LMCityPickView *cityPickView=[[LMCityPickView alloc]init];
    cityPickView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.25];
    cityPickView.selectedBlock=selectedBlock;
    [window_ addSubview:cityPickView];
    [cityPickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window_);
    }];
}
#pragma mark  - 加载数据
-(void)loadData{
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.provinceArray addObject:obj[@"name"]];
        
    }];
    NSArray *subArray1=[self.dataArray firstObject][@"sub"];
    [subArray1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.cityArray addObject:obj[@"name"]];
        [self.zipcodeArray addObject:obj[@"zipcode"]];
    }];
    NSArray *subArray2=[subArray1 firstObject][@"sub"];
    [subArray2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.areaArray addObject:obj];
        
    }];
    self.province=self.provinceArray[0];
    self.city=self.cityArray[0];
    self.area=self.areaArray[0];
    self.zipcode=self.zipcodeArray[0];
    
    
    


}
#pragma mark  - 子视图
-(void)setupSubviews{
    
   
    UIButton *btn=[[UIButton alloc]init];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containView addSubview:btn];
    
    UIView *lineView=[[UIView alloc]init];
    
    lineView.backgroundColor=[UIColor lightGrayColor];
    
    [self.containView addSubview:lineView];
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.mas_offset(0);
        
        make.height.mas_equalTo(PickContainViewHeight);
        
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_offset(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
        
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(btn.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(1);
        
    }];
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.equalTo(lineView.mas_bottom).mas_offset(0);
        
    }];
    
}
#pragma mark  - 点击完成按钮
-(void)completeAction{
    [self getCurrentInfo];
    if (self.selectedBlock) {
        self.selectedBlock(self.province,self.city,self.area,self.zipcode);
    }
    [self cancelAction];

}
#pragma mark  - 获取当前pickview的信息
-(void)getCurrentInfo{
    NSInteger selectedProvince=[self.pickView selectedRowInComponent:0];
    NSInteger selectedCity=[self.pickView selectedRowInComponent:1];
    NSInteger selectedArea=[self.pickView selectedRowInComponent:2];
    self.province=self.provinceArray[selectedProvince];
    self.city=self.cityArray[selectedCity];
    self.area=self.areaArray[selectedArea];
    self.zipcode=self.zipcodeArray[selectedCity];

}
-(UIPickerView *)pickView{
    if (!_pickView) {
        UIPickerView *pickView=[[UIPickerView alloc]init];
        pickView.delegate=self;
        pickView.dataSource=self;
        [self.containView addSubview:pickView];
        _pickView=pickView;
    }
    return _pickView;
}
-(UIView *)containView{
    if (!_containView) {
        UIView *containView=[[UIView alloc]init];
        containView.backgroundColor=[UIColor whiteColor];
        [self addSubview:containView];
        _containView=containView;
       
        
        
    }
    return _containView;
}
-(NSArray *)dataArray{
    if (!_dataArray) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
        _dataArray=dict[@"address"];
        
    }
    return _dataArray;
}
-(NSMutableArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray=@[].mutableCopy;
        
    }
    return _provinceArray;
}
-(NSMutableArray *)cityArray{
    if (!_cityArray) {
        _cityArray=@[].mutableCopy;
    }
    return _cityArray;
}
-(NSMutableArray *)areaArray{
    if (!_areaArray) {
        _areaArray=@[].mutableCopy;
    }
    return _areaArray;
}
-(NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray=@[].mutableCopy;
    }
    return _selectedArray;
}
-(NSMutableArray *)zipcodeArray{
    if (!_zipcodeArray) {
        _zipcodeArray=@[].mutableCopy;
    }
    return _zipcodeArray;
}
#pragma mark  - UIPickerViewDataSource
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    NSString *text;
    if (component==0) {
        text=self.provinceArray[row];
    }else if (component==1){
        text=self.cityArray[row];
    }else if (component==2){
        text=self.areaArray[row];
    }else{
        return nil;
    
    }
    UILabel *label=[[UILabel alloc]init];
    label.text=text;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    return label;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.provinceArray.count;
    }else if (component==1){
        return self.cityArray.count ;
    
    }else if (component==2){
        return self.areaArray.count;
    }
    return 0;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {//省级联动
        NSArray *subArray1=self.dataArray[row][@"sub"];
        //记录所有的市级资料
        self.selectedArray=[NSMutableArray arrayWithArray:subArray1];
        [self.cityArray removeAllObjects];
        [self.zipcodeArray removeAllObjects];
        [subArray1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.cityArray addObject:obj[@"name"]];
            [self.zipcodeArray addObject:obj[@"zipcode"]];
        }];
        NSArray *subArray2=[subArray1 firstObject][@"sub"];
        [self.areaArray removeAllObjects];
        [subArray2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.areaArray addObject:obj];
        }];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView selectRow:0 inComponent:2 animated:NO];
    }else if (component==1){//市级联动
        if (self.selectedArray.count==0) {
            self.selectedArray=[NSMutableArray arrayWithArray:self.dataArray[0][@"sub"]];
            
        }
      NSArray *subArray=self.selectedArray[row][@"sub"];
    [self.areaArray removeAllObjects];
      [subArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          [self.areaArray addObject:obj];
      }];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:NO];
    }
    [self getCurrentInfo];
    if (self.selectedBlock) {
        self.selectedBlock(self.province,self.city,self.area,self.zipcode);
    }
}
-(void)cancelAction{
    self.userInteractionEnabled=NO;
    window_.hidden=YES;
    window_=nil;
}













@end
