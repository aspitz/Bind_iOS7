//
//  ZLineView.h
//  Bind_iOS7
//
//  Created by Ayal Spitz on 9/3/13.
//  Copyright (c) 2013 spitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLineView : UIView

@property (nonatomic, assign) CGPoint startPt;
@property (nonatomic, assign) CGPoint endPt;

-(instancetype)initWithStartPt:(CGPoint)startPt andEndPt:(CGPoint)endPt;

@end
