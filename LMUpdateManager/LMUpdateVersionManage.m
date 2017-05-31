//
//  LMUpdateVersionManage.m
//  LHMLiveTV
//
//  Created by iOSDev on 17/5/31.
//  Copyright © 2017年 iOSDev. All rights reserved.
//

#import "LMUpdateVersionManage.h"

#define oldVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
@interface LMUpdateVersionManage ()

@property(nonatomic, copy)void(^updateBlock)(NSString *,NSString *,NSString *);
@property(nonatomic, strong)UIViewController *showController;
@end

@implementation LMUpdateVersionManage
-(instancetype)init{
    self=[super init];
    if (self) {
        __weak typeof(self) weakSelf=self;
        self.updateBlock=^(NSString *currentVersion ,NSString *releaseNotes, NSString *trackUrl){
            __strong typeof(self) strongSelf=weakSelf;
            
            [strongSelf showUpdateViewWith:(NSString *)currentVersion with:(NSString *)releaseNotes with:(NSString *)trackUrl];
            
        };
        
    }
    return self;




}
+(instancetype)shareManage{
    static LMUpdateVersionManage *manage=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage=[[self alloc]init];
        
    });
    return manage;

}
+(void)checkVersionInController:(UIViewController *)showController{
   
    NSString *storeString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@",@"com.haoontech.jiuducaijingzhi"];

    
    [LMNetworkManager GET:storeString params:nil sucessBlock:^(id object) {
        NSArray *array=object[@"results"];
        NSDictionary *dict=[array firstObject];
        NSString *currentVersion=dict[@"version"];
        if (currentVersion) {
            if ([LMUpdateVersionManage versionOlder:oldVersion sameTo:currentVersion]) {
                //暂不更新
            }else{
                //跳转到appstore更新
                NSString *releaseNotes=dict[@"releaseNotes"];
                NSString *trackUrl=dict[@"trackViewUrl"];
//                NSArray *dataArr=[LMUpdateVersionManage seperateToRow:releaseNotes];
                LMUpdateVersionManage *manage=[LMUpdateVersionManage shareManage];
                manage.showController=showController;
                if (manage.updateBlock) {
                    manage.updateBlock(currentVersion, releaseNotes,trackUrl);
                }
                
            
            
            }
        }
        
        
    } failBlock:^(NSError *error) {
        
    } progress:nil];

}
#pragma mark  - 更新界面
-(void)showUpdateViewWith:(NSString *)currentVersion with:(NSString *)releaseNotes with:(NSString *)trackUrl{
    
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现新版本%@",currentVersion] message:releaseNotes preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action0=[UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"忽略此版本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackUrl]];
        
        
    }];
    [alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self.showController presentViewController:alertController animated:YES completion:nil];





}
#pragma mark  - 版本号比较
+(BOOL)versionOlder:(NSString *)older sameTo:(NSString *)newer{
    if ([older isEqualToString:newer]) {
        return YES;
    }else{
        if ([older compare:newer options:NSNumericSearch]==NSOrderedDescending) {
            return YES;
        }else{
            return NO;
        }
    }
}
#pragma mark  - 字符串分割
+(NSArray *)seperateToRow:(NSString *)describe{
    
    NSArray *array=[describe componentsSeparatedByString:@"\n"];
    return array;

}













@end
