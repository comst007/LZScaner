//
//  UIView+LZFrame.m
//  LZBSBuDeJie
//
//  Created by comst on 16/3/4.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "UIView+LZFrame.h"

@implementation UIView (LZFrame)
- (CGFloat)width{
    return self.frame.size.width;
    
   
    
}

-(CGFloat)centerX{
    
    CGPoint center = self.center;
    return center.x;
}

- (CGFloat)centerY{
    CGPoint center = self.center;
    return center.y;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGFloat)x{
    CGPoint orign = self.frame.origin;
    return orign.x;
}

- (CGFloat)y{
    CGPoint origin = self.frame.origin;
    return origin.y;
}

- (void)setWidth:(CGFloat)width{
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

@end
