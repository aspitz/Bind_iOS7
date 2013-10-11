//
//  NodeModel.m
//
//  Created by Ayal Spitz on 7/21/11.
//  Copyright 2011 Ayal Spitz. All rights reserved.
//

#import "NodeModel.h"
#import <stdlib.h>

@implementation NodeModel

- (id)init{
    self = [super init];
    if (self) {
        self.pt = CGPointZero;
        _hashStr = [NSString stringWithFormat:@"%d", [(NSObject *)self hash]];
    }
    
    return self;
}

@end
