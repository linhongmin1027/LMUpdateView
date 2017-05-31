//
//  LMNetworkManager.h
//  LMThirdParty
//
//  Created by iOSDev on 17/5/3.
//  Copyright © 2017年 linhongmin. All rights reserved.
//  网络请求类

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
typedef NS_ENUM(NSUInteger, MonitorNetworkState){ //网络状态
    MonitorNetworkStateUnknown ,
    MonitorNetworkStateNotReachable ,
    MonitorNetworkStateWWAN ,
    MonitorNetworkStateWiFi

};
typedef NS_ENUM(NSUInteger , NetworkStates){
    NetworkStatesNone  =0,  //没有网络
    NetworkStates2G,    //2G
    NetworkStates3G,    //3G
    NetworkStates4G,    //4G
    NetworkStatesWIFI   //WIFI

};

/**  成功  */
typedef void(^requestSucess) (id object);
/**  失败  */
typedef void(^requestFailure) (NSError *error);
/**  上传进度 */
typedef void(^uploadProgress)(float progress);
/**  下载进度  */
typedef void(^downloadProgress)(float progress);

@interface LMNetworkManager : AFHTTPSessionManager

//+(instancetype)shareManager;
/**  GET请求  */
+(void)GET:(NSString *)urlString params:(id)params sucessBlock:(requestSucess)successBlock failBlock:(requestFailure)failBlock progress:(downloadProgress)progress;
/**  POST请求  */
+(void)POST:(NSString *)urlString params:(id)params sucessBlock:(requestSucess)successBlock failBlock:(requestFailure)failBlock progress:(downloadProgress)progress;



@end
