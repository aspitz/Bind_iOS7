//
//  NodeModel.h
//
//  Created by Ayal Spitz on 7/21/11.
//  Copyright 2011 Ayal Spitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NodeModel : NSObject

@property (nonatomic, assign) CGPoint pt;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, readonly) NSString *hashStr;

@end
