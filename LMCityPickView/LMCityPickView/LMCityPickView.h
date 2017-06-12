//
//  LMCityPickView.h
//  LHMLiveTV
//
//  Created by iOSDev on 17/5/31.
//  Copyright © 2017年 iOSDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMCityPickView : UIView
+(void)showWithSelectedBlock:(void(^)(NSString *province,NSString *ciry,NSString *area,NSString*zipcode))selectedBlock;
@end
