//
//  KeyboardAttachedView.m
//  UniversalTool
//
//  Created by DeHaoYang on 15/11/10.
//  Copyright © 2015年 YDH. All rights reserved.
//

#import "KeyboardAttachedView.h"
@implementation KeyboardAttachedView
//单例实现
+ (KeyboardAttachedView *)sharedManager
{
    static KeyboardAttachedView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
//外部方法
+(void)addAttachedView:(UIView *)view withTextObject:(id)textObject
{
    [[KeyboardAttachedView sharedManager]addAttachedView:view withTextObject:textObject];
}
//内部方法
-(void)addAttachedView:(UIView *)view withTextObject:(id)textObject
{
    self.attachedView=view;
    self.originalRect=view.frame;
    self.textObject=textObject;
    //监听键盘信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notif
{
    //当只有是对应的text对象引起键盘活动才改变view位置，保证安全
    if ([_textObject isFirstResponder])
    {
        //获取键盘信息
        NSDictionary *keyboardInfo=[notif userInfo];
        //键盘frame信息
        NSValue *value = [keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [value CGRectValue];
        //获取键盘动画时间
        NSValue *animationDurationValue = [keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        //获取键盘动画类型
        NSValue *animationCurveObject = [keyboardInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
        NSUInteger animationCurve;
        [animationCurveObject getValue:&animationCurve];
        //动画开始(时间、类型都和键盘一样)
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
        //只改动view的y坐标（键盘y-view的高度）
        _attachedView.frame=CGRectMake(_attachedView.frame.origin.x, keyboardRect.origin.y-_attachedView.frame.size.height, _attachedView.frame.size.width, _attachedView.frame.size.height);
        [UIView commitAnimations];
    }
  
}

- (void)keyboardWillHidden:(NSNotification *)notif
{
    //当只有是对应的text对象引起键盘活动才改变view位置，保证安全
    if ([_textObject isFirstResponder])
    {
        //获取键盘信息
        NSDictionary *keyboardInfo=[notif userInfo];
        //获取键盘动画时间
        NSValue *animationDurationValue = [keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        //获取键盘动画类型
        NSValue *animationCurveObject = [keyboardInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
        NSUInteger animationCurve;
        [animationCurveObject getValue:&animationCurve];
        //动画开始(时间、类型都和键盘一样)
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
        //只改动view的y坐标（view的y+键盘Height）
        _attachedView.frame=_originalRect;
        [UIView commitAnimations];
    }
}
//释放通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
