//
//  KeyboardAttachedView.h
//  UniversalTool
//
//  Created by DeHaoYang on 15/11/10.
//  Copyright © 2015年 YDH. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface KeyboardAttachedView : NSObject
/*
 KeyboardAttachedView工具类 便捷实现View等控件跟随键盘移动
 直接调用addAttachedView 方法即可
 注意事项  最好一个页面里面就只有一个输入框（本身只根据传进来的输入框有效）如果需要多个输入框都有效时、修改.m中
 [_textObject isFirstResponder]的判断
*/
//键盘附属View
@property(nonatomic,strong)UIView *attachedView;
//键盘附属View的原始rect
@property(nonatomic,assign)CGRect originalRect;
//引起键盘反应的textField或者textView
@property(nonatomic,strong)id textObject;
//添加键盘附属View（键盘上面的View）1、view为跟随键盘移动的View对象2、textObject是textField或者textView对象
+(void)addAttachedView:(UIView *)view withTextObject:(id)textObject;
@end
