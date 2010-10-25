//
//  MGSplitDividerView.h
//  MGSplitView
//
//  Created by Matt Gemmell on 26/07/2010.
//  Copyright 2010 Instinctive Code.
//

#import <UIKit/UIKit.h>

@interface MGDividerArrow : UIView {}

- (void) flip;
@end


@class MGSplitViewController;
@interface MGSplitDividerView : UIView {
	MGSplitViewController *splitViewController;
	BOOL allowsDragging;
	BOOL isRetracted;
	MGDividerArrow *dividerArrow;
}

@property (nonatomic, assign) MGSplitViewController *splitViewController; // weak ref.
@property (nonatomic, assign) BOOL allowsDragging;

- (void) togglePosition;

@end



