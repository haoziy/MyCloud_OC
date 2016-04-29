//
//  HomeResourceManager.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJResourceManager.h"

@interface HomeResourceManager : MRJResourceManager

/**
 *  设备图标,大
 *
 *  @return
 */
+(UIImage*)home_searchDeviceLogo;

/**
 *  设备参数界面移动右边箭头
 *
 *  @return 
 */
+(UIImage*)home_deviceParamArrow;

/**
 *  搜索界面返回button图标
 *
 *  @return 
 */
+(UIImage*)home_searchBackIcon;

/**
 *  配置网络界面返回button图标
 *
 *  @return
 */
+(UIImage*)home_configNetBackIcon;


/**
 *  配置网选中按钮
 *
 *  @return
 */
+(UIImage*)home_configNetSelectedBtnImage;

/**
 *  配置网络未选中按钮image
 *
 *  @return 
 */
+(UIImage*)home_configNetUnSelectedBtnImage;
@end
