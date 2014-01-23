//
//  ShotCell.m
//  Dribbble
//
//  Created by John Andrews on 1/23/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "ShotCell.h"

@implementation ShotCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.shotImageView.image = nil;
}

@end
