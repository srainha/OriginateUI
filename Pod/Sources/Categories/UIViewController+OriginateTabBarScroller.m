//
//  UIViewController+OriginateTabBarScroller.m
//  OriginateUI
//
//  Created by William Tachau on 10/1/15.
//  Copyright © 2015 Originate. All rights reserved.
//

#import "UIViewController+OriginateTabBarScroller.h"
#import <objc/runtime.h>

@implementation UIViewController (OriginateTabBarScroller)

// The previous scroll offset
- (void)setOri_PreviousScrollViewOffset:(CGFloat)previousScrollViewOffset
{
    objc_setAssociatedObject(self, @selector(ori_previousScrollViewOffset), @(previousScrollViewOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ori_previousScrollViewOffset
{
    return [objc_getAssociatedObject(self, @selector(ori_previousScrollViewOffset)) floatValue];
}

// The initial content offset
- (void)setOri_InitialContentOffset:(CGFloat)contentOffset
{
    objc_setAssociatedObject(self, @selector(ori_initialContentOffset), @(contentOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ori_initialContentOffset
{
    return [objc_getAssociatedObject(self, @selector(ori_initialContentOffset)) floatValue];
}

- (void)slideTabBar:(UITabBar *)tabBar inResponseToScrollInScrollView:(UIScrollView *)scrollView
{
    // Calculate the default origin for the tab bar
    CGRect viewportRect = [[[[UIApplication sharedApplication] delegate] window] bounds];
    CGFloat screenHeight = viewportRect.size.height;
    CGFloat originalTabBarOrigin = screenHeight - tabBar.frame.size.height;
    
    CGRect tabBarFrame = tabBar.frame;

    // Determine the difference up or down that has been scrolled
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat deltaScrollOffset = (scrollOffset - self.ori_previousScrollViewOffset);
    [self setOri_PreviousScrollViewOffset:scrollOffset];
    
    // Calculate the initial content offset
    if (!self.ori_initialContentOffset) {
        [self setOri_InitialContentOffset:scrollOffset];
    }

    // Calculate what the offset would be, assuming the tab bar wouldn't go off screen
    CGFloat potentialTabBarOffset = (tabBarFrame.origin.y - originalTabBarOrigin) + deltaScrollOffset;
    CGFloat maxTabBarOffset = tabBarFrame.size.height;
    
    // Don't set the origin any lower than the bottom limit of the screen
    CGFloat lowestPossibleOffset = MIN(maxTabBarOffset, potentialTabBarOffset);
    // But don't set the origin below the default origin for the tab bar, either
    CGFloat optimalTabBarOffset = MAX(0, lowestPossibleOffset);
    
    // Only change tab bar if the user hasn't scrolled off above or below the scroll view
    CGFloat scrollHeight = scrollView.frame.size.height;
    BOOL isAtBottomOfScrollView = (scrollOffset + scrollHeight) >= scrollView.contentSize.height;
    if (scrollOffset > self.ori_initialContentOffset && !isAtBottomOfScrollView) {
        tabBarFrame.origin.y = originalTabBarOrigin + optimalTabBarOffset;
        tabBar.frame = tabBarFrame;
    }
}

@end
