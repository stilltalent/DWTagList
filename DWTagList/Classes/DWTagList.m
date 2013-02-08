//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 10.0f
#define LABEL_MARGIN 5.0f
#define BOTTOM_MARGIN 5.0f
#define FONT_SIZE 13.0f
#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING 3.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor].CGColor
#define BORDER_WIDTH 1.0f

@interface DWTagList(){
    __weak DWTagList *weakself;
}

- (void)touchedTag:(id)sender;

@end

@implementation DWTagList

@synthesize view, textArray;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:view];
        weakself = self;
        
        self.highlightedBackgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00];
    }
    return self;
}

- (void)setTags:(NSArray *)array {
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)setLabelBackgroundColor:(UIColor *)color {
    lblBackgroundColor = color;
    [self display];
}

- (void)display {
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    
    NSLog(@"%@", textArray);
    
    for (NSString *text in textArray) {
        CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"OpenSans" size:FONT_SIZE] constrainedToSize:CGSizeMake(self.frame.size.width, 1500) lineBreakMode:NSLineBreakByWordWrapping];
        textSize.width += HORIZONTAL_PADDING*2;
        textSize.height += VERTICAL_PADDING*2;
        
        UIButton *button = nil;
        if (!gotPreviousFrame) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > weakself.frame.size.width) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            newRect.size = textSize;
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:newRect];
        }
        previousFrame = button.frame;
        gotPreviousFrame = YES;
        [button.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:FONT_SIZE]];
        if (!lblBackgroundColor) {
            [button setBackgroundColor:BACKGROUND_COLOR];
        } else {
            [button setBackgroundColor:lblBackgroundColor];
        }
        [button setTitle:text forState:UIControlStateNormal];
        [button setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [button setTitleShadowColor:TEXT_SHADOW_COLOR forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor colorWithWhite:1.000 alpha:0.5] forState:UIControlStateHighlighted];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button.titleLabel setShadowOffset:TEXT_SHADOW_OFFSET];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:CGRectGetHeight(button.frame) / 2];
        [button.layer setBorderColor:BORDER_COLOR];
        [button.layer setBorderWidth:BORDER_WIDTH];
        
        if (!self.viewOnly) {
            [button addTarget:self action:@selector(touchDownInside:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
            [button addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
        }
        [self addSubview:button];
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);
}

- (void) setViewOnly:(BOOL)viewOnly{
    if (_viewOnly != viewOnly) {
        _viewOnly = viewOnly;
        [self display];
    }
}

- (CGSize)fittedSize {
    return sizeFit;
}

-(void)touchDownInside:(id)sender {
    UIButton *button = (UIButton*)sender;
    [button setBackgroundColor:self.highlightedBackgroundColor];
}

-(void)touchUpInside:(id)sender {
    UIButton *button = (UIButton*)sender;
    if (button && self.delegate && [self.delegate respondsToSelector:@selector(selectedTagText:)]) {
        [self.delegate selectedTagText:button.titleLabel.text];
    }
    if (button && self.delegate && [self.delegate respondsToSelector:@selector(selectedTagButton:)]) {
        [self.delegate selectedTagButton:button];
    }
    [button setBackgroundColor:BACKGROUND_COLOR];
}

-(void)touchDragExit:(id)sender {
    UIButton *button = (UIButton*)sender;
    [button setBackgroundColor:BACKGROUND_COLOR];
}

-(void)touchDragInside:(id)sender {
    UIButton *button = (UIButton*)sender;
    [button setBackgroundColor:self.highlightedBackgroundColor];
}

@end
