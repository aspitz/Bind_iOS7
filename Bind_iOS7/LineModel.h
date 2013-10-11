//
//  LineModel.h
//  Bind_iOS7
//
//  Created by Ayal Spitz on 9/3/13.
//  Copyright (c) 2013 spitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NodeModel;

@interface LineModel : NSObject

@property (nonatomic, strong) NodeModel *startNode;
@property (nonatomic, assign) NodeModel *endNode;

@end
