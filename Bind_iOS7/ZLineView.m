//
//  ZLineView.m
//  Bind_iOS7
//
//  Created by Ayal Spitz on 9/3/13.
//  Copyright (c) 2013 spitz. All rights reserved.
//

#import "ZLineView.h"

@implementation ZLineView

-(instancetype)initWithStartPt:(CGPoint)startPt andEndPt:(CGPoint)endPt{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;

        _startPt = startPt;
        _endPt = endPt;
        [self reposition];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint pt = self.frame.origin;
    
    CGContextSetLineWidth(context, 1.0);
    [[UIColor darkGrayColor]setStroke];
    CGContextMoveToPoint(context, self.startPt.x - pt.x, self.startPt.y - pt.y);
    CGContextAddLineToPoint(context, self.endPt.x - pt.x, self.endPt.y - pt.y);
    CGContextStrokePath(context);
}

- (void)setStartPt:(CGPoint)pt{
    _startPt = pt;
    [self reposition];
}

- (void)setEndPt:(CGPoint)pt{
    _endPt = pt;
    [self reposition];
}

- (void)reposition{
    CGPoint minPt = CGPointMake(MIN(self.startPt.x, self.endPt.x), MIN(self.startPt.y, self.endPt.y));
    CGPoint maxPt = CGPointMake(MAX(self.startPt.x, self.endPt.x), MAX(self.startPt.y, self.endPt.y));
    
    CGRect frame = CGRectMake(minPt.x, minPt.y, maxPt.x - minPt.x, maxPt.y - minPt.y);
    self.frame = CGRectInset(frame, -2.0, -2.0);

    [self setNeedsDisplay];
}

@end
