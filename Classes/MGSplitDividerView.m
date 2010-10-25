//
//  MGSplitDividerView.m
//  MGSplitView
//
//  Created by Matt Gemmell on 26/07/2010.
//  Copyright 2010 Instinctive Code.
//

#import "MGSplitDividerView.h"
#import "MGSplitViewController.h"


@implementation MGSplitDividerView

#define kArrowWidth 10.0f
#define kArrowHeight 15.0f
#define kArrowTag 100

#pragma mark -
#pragma mark Setup and teardown


- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;
		self.allowsDragging = NO;
		self.contentMode = UIViewContentModeRedraw;
		isRetracted = NO;
	}
	return self;
}


- (void)dealloc
{
	self.splitViewController = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Drawing


- (void)drawRect:(CGRect)rect
{
	if (splitViewController.dividerStyle == MGSplitViewDividerStyleThin) {
		[super drawRect:rect];
		
	} else if (splitViewController.dividerStyle == MGSplitViewDividerStylePaneSplitter) {
		// Draw gradient background.
		CGRect bounds = self.bounds;
		CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
		CGFloat locations[2] = {0, 1};
		CGFloat components[8] = {	0.988, 0.988, 0.988, 1.0,  // light
									0.875, 0.875, 0.875, 1.0 };// dark
		CGGradientRef gradient = CGGradientCreateWithColorComponents (rgb, components, locations, 2);
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGPoint start, end;
		if (splitViewController.vertical) {
			// Light left to dark right.
			start = CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds));
			end = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds));
		} else {
			// Light top to dark bottom.
			start = CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds));
			end = CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
		}
		CGContextDrawLinearGradient(context, gradient, start, end, 0);
		CGColorSpaceRelease(rgb);
		CGGradientRelease(gradient);
		
		// Draw borders.
		float borderThickness = 1.0;
		[[UIColor colorWithWhite:0.7 alpha:1.0] set];
		CGRect borderRect = bounds;
		if (splitViewController.vertical) {
			borderRect.size.width = borderThickness;
			UIRectFill(borderRect);
			borderRect.origin.x = CGRectGetMaxX(bounds) - borderThickness;
			UIRectFill(borderRect);
			
		} else {
			borderRect.size.height = borderThickness;
			UIRectFill(borderRect);
			borderRect.origin.y = CGRectGetMaxY(bounds) - borderThickness;
			UIRectFill(borderRect);
		}
		
		if ([self viewWithTag:kArrowTag] == nil) {
			CGFloat arrowYPos = (self.bounds.size.height / 2) - (kArrowHeight / 2);
			dividerArrow = [[MGDividerArrow alloc] initWithFrame:CGRectMake(2.0, arrowYPos, kArrowWidth, kArrowHeight)];
			NSLog(@"Arrow Added");
			[self addSubview:dividerArrow];
		}
		
	}
}


#pragma mark -
#pragma mark Interaction


- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	[self togglePosition];
	
}

- (void) togglePosition{
	if (isRetracted) {
		splitViewController.splitPosition = 320.0f;
		isRetracted = NO;
	}else {
		splitViewController.splitPosition = 0.0f;
		isRetracted = YES;
	}
	[dividerArrow flip];
}

#pragma mark -
#pragma mark Accessors and properties


- (void)setAllowsDragging:(BOOL)flag
{
	if (flag != allowsDragging) {
		allowsDragging = flag;
		self.userInteractionEnabled = allowsDragging;
	}
}


@synthesize splitViewController;
@synthesize allowsDragging;


@end

@implementation MGDividerArrow



- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor clearColor];
		self.tag = kArrowTag;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.36f green:0.39f blue:0.45f alpha:1.0f] CGColor]);
#if __IPHONE_3_2
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 0.0f, [[UIColor whiteColor] CGColor]);
#else
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, -1.0f), 0.0f, [[UIColor whiteColor] CGColor]);
#endif
	CGFloat height = rect.size.height;
	CGFloat width = rect.size.width;
	CGContextMoveToPoint(context, 0.0f, height/2);
	CGContextAddLineToPoint(context, width, 0.0);
	CGContextAddLineToPoint(context, width, height);
    CGContextFillPath(context);
}

-(void) flip{
	self.transform = CGAffineTransformRotate(self.transform, M_PI);
}

@end

