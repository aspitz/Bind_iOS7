//
//  ZViewController.m
//  Bind_iOS7
//
//  Created by Ayal Spitz on 8/26/13.
//  Copyright (c) 2013 spitz. All rights reserved.
//

#import "ZViewController.h"
#import "BindingManager.h"
#import "NodeModel.h"
#import "LineModel.h"
#import "UIView+Gestures.h"
#import "NSMutableDictionary+NSObjectKeys.h"
#import "PanGestureRecognizer.h"
#import "CollectionBind.h"
#import "UIGestureRecognizer+View.h"
#import "ZLineView.h"

@interface ZViewController ()

@property (nonatomic, strong) NodeModel *currentNodeModel;

@end


@implementation ZViewController

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.viewModelDictionary = [[NSMutableDictionary alloc]init];
    
    [self.view recognizeTapGestureWithTarget:self action:@selector(handleTapGesture:)];
    [self.view recognizeDoubleTapGestureWithTarget:self action:@selector(handleDoubleTapGesture:)];
    [self.view recognizePanGestureWithTarget:self action:@selector(handlePanGesture:)];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
    
    self.nodeLineDictionary = [NSMutableDictionary dictionary];
    
    self.lineModels = [NSMutableSet set];
    self.models = [NSMutableSet set];
    [BindingManager bindCollection:@"view" of:self to:@"models" of:self
                           withAdd:^(NSObject *value, NSObject *obj, NSString *keyPath){
                               NodeModel *aModel = (NodeModel *)value;
                               ZViewController *blockSelf = (ZViewController *)obj;
                               
                               // Create a view
                               UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
                               aView.center = aModel.pt;
                               aView.backgroundColor = aModel.selected ? [UIColor yellowColor] : [UIColor grayColor];
                               aView.userInteractionEnabled = YES;
                               [blockSelf.view addSubview:aView];
                               
                               // Bind the views center to the model.pt
                               [BindingManager bind:@"center" of:aView to:@"pt" of:aModel];
                               [BindingManager bind:@"backgroundColor" of:aView to:@"selected" of:aModel withTransform:^NSObject *(NSObject *srcValue) {
                                   NSNumber *number = (NSNumber *)srcValue;
                                   return [number boolValue] ? [UIColor yellowColor] : [UIColor grayColor];
                               }];
                               [blockSelf.viewModelDictionary setObject:aModel forNSObjectKey:aView];
                               [blockSelf.viewModelDictionary setObject:aView forNSObjectKey:aModel];
                           }
                         andRemove:^(NSObject *value, NSObject *obj, NSString *keyPath) {
                             NodeModel *aModel = (NodeModel *)value;
                             ZViewController *blockSelf = (ZViewController *)obj;
                             
                             UIView *aView = [blockSelf.viewModelDictionary objectForNSObjectKey:aModel];
                             
                             [blockSelf.viewModelDictionary removeObjectForNSObjectKey:aModel];
                             [blockSelf.viewModelDictionary removeObjectForNSObjectKey:aView];
                             
                             [aView removeFromSuperview];
                             
                             NSMutableSet *lineSet = self.nodeLineDictionary[aModel.hashStr];
                             [lineSet enumerateObjectsUsingBlock:^(LineModel *lineModel, BOOL *stop) {
                                 UIView *line = [blockSelf.viewModelDictionary objectForNSObjectKey:lineModel];
                                 [blockSelf.viewModelDictionary removeObjectForNSObjectKey:line];
                                 [line removeFromSuperview];
                             }];
                         }
     ];
    
    [BindingManager bind:@"count.text" of:self to:@"models.@count" of:self
           withTransform:^NSObject *(NSObject *inObj){
               return [inObj description];
           }
     ];
}

// Handle the pan gesture
- (void)handlePanGesture:(UIGestureRecognizer *)gestureRecognizer{
    UIView *tempView = ((PanGestureRecognizer *)gestureRecognizer).startingView;
    
    CGPoint pt = [gestureRecognizer locationInView:self.view];
    
    NodeModel *model = [self.viewModelDictionary objectForNSObjectKey:tempView];
    
    // Update the models point
    model.pt = pt;
}

// Handle the tap gesture
- (void)handleTapGesture:(UIGestureRecognizer *)gestureRecognizer{
    UIView *tempView = [gestureRecognizer touchedView];
    
    if (tempView == self.view){
        [self addNodeAt:[gestureRecognizer locationInView:self.view]];
    }
}

// Handle the double tap gesture
- (void)handleDoubleTapGesture:(UIGestureRecognizer *)gestureRecognizer{
    UIView *tempView = [gestureRecognizer touchedView];
    
    if (tempView != self.view){
        NodeModel *aModel = [self.viewModelDictionary objectForNSObjectKey:tempView];
        NSMutableSet *modelSet = [self mutableSetValueForKeyPath:@"models"];
        [modelSet removeObject:aModel];
    }
}

// Handle the long press gesture
- (void)handleLongPressGesture:(UIGestureRecognizer *)gestureRecognizer{
    UIView *tempView = [gestureRecognizer touchedView];
    NodeModel *model = [self.viewModelDictionary objectForNSObjectKey:tempView];

    if ((self.currentNodeModel != nil) || (model != nil)){
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
                self.currentNodeModel = [self addNodeAt:[gestureRecognizer locationInView:self.view]];
                self.currentNodeModel.selected = YES;
                [self addLineFrom:model to:self.currentNodeModel];
                break;
            case UIGestureRecognizerStateChanged:
                self.currentNodeModel.pt = [gestureRecognizer locationInView:self.view];
                break;
            case UIGestureRecognizerStateEnded:
                self.currentNodeModel.selected = NO;
                self.currentNodeModel = nil;
                break;
            default:
                break;
        }
    }
}

#pragma mark -

- (NodeModel *)addNodeAt:(CGPoint)pt{
    NodeModel *aModel = [[NodeModel alloc]init];
    aModel.pt = pt;
    
    // Bind the label text to the model.pt using a transform
    [BindingManager bind:@"location.text" of:self to:@"pt" of:aModel
           withTransform:^NSObject *(NSObject *inObj){
               CGPoint pt = [((NSValue *)inObj) CGPointValue];
               return [NSString stringWithFormat:@"%f,%f", pt.x, pt.y];
           }
     ];
    
    NSMutableSet *modelSet = [self mutableSetValueForKeyPath:@"models"];
    [modelSet addObject:aModel];

    return aModel;
}

- (LineModel *)addLineFrom:(NodeModel *)startNode to:(NodeModel *)endNode{
    LineModel *lineModel = [[LineModel alloc]init];
    
    lineModel.startNode = startNode;
    lineModel.endNode = endNode;

    NSMutableSet *modelSet = [self mutableSetValueForKeyPath:@"lineModels"];
    [modelSet addObject:lineModel];
    
    ZLineView *lineView = [[ZLineView alloc]initWithStartPt:startNode.pt andEndPt:endNode.pt];
    [self.view addSubview:lineView];
    [self.view sendSubviewToBack:lineView];
    [self.viewModelDictionary setObject:lineModel forNSObjectKey:lineView];
    
    [BindingManager bind:@"startPt" of:lineView to:@"pt" of:lineModel.startNode];
    [BindingManager bind:@"endPt" of:lineView to:@"pt" of:lineModel.endNode];

    [self.viewModelDictionary setObject:lineModel forNSObjectKey:lineView];
    [self.viewModelDictionary setObject:lineView forNSObjectKey:lineModel];

    NSMutableSet *lineSet = self.nodeLineDictionary[startNode.hashStr];
    if (lineSet == nil){
        lineSet = [NSMutableSet set];
        self.nodeLineDictionary[startNode.hashStr] = lineSet;
    }
    [lineSet addObject:lineModel];

    lineSet = self.nodeLineDictionary[endNode.hashStr];
    if (lineSet == nil){
        lineSet = [NSMutableSet set];
        self.nodeLineDictionary[endNode.hashStr] = lineSet;
    }
    [lineSet addObject:lineModel];

    
    return lineModel;
}

@end
