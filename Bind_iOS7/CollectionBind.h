//
//  CollectionBind.h
//  Bind
//
//  Created by Ayal Spitz on 8/25/11.
//  Copyright (c) 2011 Ayal Spitz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AddBlock)(NSObject *, NSObject *, NSString *);
typedef void(^RemoveBlock)(NSObject *, NSObject *, NSString *);

@interface CollectionBind : NSObject

@property (nonatomic, strong) NSObject *srcObj;
@property (nonatomic, copy) NSString *srcKeyPath;

@property (nonatomic, strong) NSObject *dstObj;
@property (nonatomic, copy) NSString *dstKeyPath;

@property (nonatomic, copy) AddBlock addBlock;
@property (nonatomic, copy) RemoveBlock removeBlock;

- (id)initWithSrc:(NSObject *)src srcKeyPath:(NSString *)srcPath dst:(NSObject *)dst andDstKeyPath:(NSString *)dstPath withAdd:(AddBlock)aBlock andRemove:(RemoveBlock)rBlock;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

- (void)remove;

@end
