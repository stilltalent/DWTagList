//
//  DWTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWTagListDelegate <NSObject>
@optional
- (void)selectedTagText:(NSString*)tagName;
- (void)selectedTagButton:(UIButton*)tagButton;
@end

@interface DWTagList : UIView {
    UIView *view;
    NSArray *textArray;
    CGSize sizeFit;
    UIColor *lblBackgroundColor;
}

@property (nonatomic) BOOL viewOnly;

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) id<DWTagListDelegate> delegate;

- (void)setLabelBackgroundColor:(UIColor *)color;
- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;

@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

@end
