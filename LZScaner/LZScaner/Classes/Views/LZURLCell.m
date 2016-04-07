//
//  LZURLCell.m
//  LZScaner
//
//  Created by comst on 16/4/7.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZURLCell.h"

@implementation LZURLCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setup];
        
    }
    
    return self;
}


- (void)setup{
    
    self.textLabel.textColor = [UIColor colorWithRed:0 green:112 / 255.0 blue:255.0 / 255.0 alpha:1];
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"urlcellbkimge"]];
}

@end
