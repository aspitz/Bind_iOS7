//
//  ZViewController.h
//  Bind_iOS7
//
//  Created by Ayal Spitz on 7/21/11.
//  Copyright 2011 Ayal Spitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionBind;

@interface ZViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *viewModelDictionary;
@property (nonatomic, strong) IBOutlet UILabel *location;
@property (nonatomic, strong) IBOutlet UILabel *count;
@property (nonatomic, strong) NSMutableSet *models;

@property (nonatomic, strong) NSMutableSet *lineModels;
@property (nonatomic, strong) NSMutableDictionary *nodeLineDictionary;

- (void)handlePanGesture:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleTapGesture:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleDoubleTapGesture:(UIGestureRecognizer *)gestureRecognizer;

@end
