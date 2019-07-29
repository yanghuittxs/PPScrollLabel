//
//  PPScrollLabel.h
//  scrollLabel
//
//  Created by Young on 2019/7/19.
//  Copyright © 2019 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPScrollLabel : UIView
@property (nonatomic, assign, readonly) BOOL   containsXView;/**< */
@property (nonatomic, assign) CGFloat   scrollDuration;/**< 滚动时间*/
@property (nonatomic, assign) CGFloat   scaleDuration;/**< 放大时间*/
@property (nonatomic, assign) NSInteger   limitScrollNum;/**< */
@property (nonatomic, copy) void(^scrollAnimationComplete)(void);/**< */

- (instancetype)initWithFrame:(CGRect)frame withContainsXView:(BOOL)isContains;

- (void)startAnimationWithNumbers:(NSInteger)nums;
@end

NS_ASSUME_NONNULL_END
