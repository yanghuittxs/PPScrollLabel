//
//  PPScrollLabel.m
//  scrollLabel
//
//  Created by Young on 2019/7/19.
//  Copyright © 2019 Young. All rights reserved.
//

#import "PPScrollLabel.h"

static NSInteger kNum = 20;
NSString * const kFontNamePFSC_Regular = @"PingFangSC-Regular";
NSString * const kFontNamePFSC_Medium = @"PingFangSC-Medium";
NSString * const kFontNamePFSC_Semibold = @"PingFangSC-Semibold";
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
//#define random (arc4random() % 255)

@interface PPScrollLabel ()
<UIScrollViewDelegate>

@property (nonatomic, assign, readwrite) BOOL   containsXView;/**< */
@property (nonatomic, strong) UILabel   *xLabel;/**< */
@property (nonatomic, assign) CGSize   itemSize;/**< */
@property (nonatomic, assign) NSInteger   recordNums;/**< */
@property (nonatomic, assign) NSInteger   currentNums;/**< */
@property (nonatomic, strong) NSMutableArray   *bitLayerArray;/**< */
@property (nonatomic, assign) NSInteger   emptyNum;/**< */
@property (nonatomic, assign) BOOL   isAnimation;/**< */

@end

@implementation PPScrollLabel

- (instancetype)initWithFrame:(CGRect)frame withContainsXView:(BOOL)isContains {
    if (self = [super initWithFrame:frame]) {
        _containsXView = isContains;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    _recordNums = 0;
    _currentNums = 0;
    _limitScrollNum = 10;
    _scaleDuration = 0.2;
    _scrollDuration = 0.2;
    _emptyNum = 0;
    _isAnimation = NO;
    _itemSize = CGSizeMake(18.0, 42.0);
    if (_containsXView) {
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.text = [NSString stringWithFormat:@"X"];
        numLabel.textColor = UIColorFromRGB(0xFFD600);
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont fontWithName:kFontNamePFSC_Regular size:30.0];
        [self addSubview:numLabel];
        self.xLabel = numLabel;
        self.xLabel.hidden = YES;
        self.xLabel.frame = CGRectMake(0, (self.frame.size.height - self.itemSize.height) / 2, _itemSize.width, _itemSize.height);
    }
    
    int itemCount = (int)floor((CGRectGetWidth(self.frame) - (self.containsXView ? _itemSize.width : 0)) / _itemSize.width);
    for (int i = 0; i < itemCount; i++) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i * _itemSize.width + (self.containsXView ? _itemSize.width : 0), 0, _itemSize.width, _itemSize.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(_itemSize.width, kNum * _itemSize.height);
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.delegate = self;
        scrollView.hidden = YES;
        [self addSubview:scrollView];
        [self.bitLayerArray addObject:scrollView];
        for (int j = 0; j < kNum; j++) {
//            UILabel *text = [[UILabel alloc] init];
//            text.backgroundColor = [UIColor clearColor];
//            text.textAlignment = NSTextAlignmentCenter;
//            text.frame = CGRectMake(0, j *_itemSize.height, _itemSize.width, _itemSize.height);
//            text.font = [UIFont fontWithName:kFontNamePFSC_Medium size:30.0];
//            text.textColor = UIColorFromRGB(0xFFD600);
//            [scrollView addSubview:text];
//            text.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:j % 10]];
            
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.backgroundColor = [UIColor clearColor].CGColor;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [NSNumber numberWithInt:j % 10]] attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNamePFSC_Medium size:30.0], NSForegroundColorAttributeName:UIColorFromRGB(0xFFD600)}];;
            textLayer.frame = CGRectMake(0, j *_itemSize.height, _itemSize.width, _itemSize.height);
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.string = attr;
            [scrollView.layer addSublayer:textLayer];
        }
    }
}

- (void)startAnimationWithNumbers:(NSInteger)nums {
    if (nums <= 0) {
        return;
    }
    if (self.isAnimation) {
        self.emptyNum += nums;
        return;
    }
    self.isAnimation = YES;
    self.currentNums = self.recordNums + nums;
    self.emptyNum = 0;
    NSString *currentStr = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.currentNums]];
    while (currentStr.length > self.bitLayerArray.count) {
        currentStr = [currentStr substringToIndex:currentStr.length - 1];
        self.currentNums = currentStr.integerValue;
    }
    for (int i = 0; i <currentStr.length; i++) {
        UIScrollView *scrollView = self.bitLayerArray[i];
        scrollView.hidden = NO;
    }
    self.xLabel.hidden = NO;
    [self readyScroll];
}

- (void)readyScroll {
    __weak typeof(self)weakself = self;
    if (self.recordNums) {//不是第一次
        if (self.currentNums - self.recordNums >= self.limitScrollNum) {//缩放+滚动
            [self sacaleAnimation:^{
            }];
            [self setDataScroll:YES complete:^{
                weakself.recordNums = weakself.currentNums;
                weakself.isAnimation = NO;
                if (weakself.emptyNum) {
                    [weakself startAnimationWithNumbers:weakself.emptyNum];
                }
                else {
                    if (weakself.scrollAnimationComplete) {
                        weakself.scrollAnimationComplete();
                    }
                }
            }];
        }
        else {//缩放
            [self setDataScroll:NO complete:^{
                
            }];
            [self sacaleAnimation:^{
                weakself.recordNums = weakself.currentNums;
                weakself.isAnimation = NO;
                if (weakself.emptyNum) {
                    [weakself startAnimationWithNumbers:weakself.emptyNum];
                }
                else {
                    if (weakself.scrollAnimationComplete) {
                        weakself.scrollAnimationComplete();
                    }
                }
            }];
        }
    }
    else {//第一次
        if (self.currentNums >= self.limitScrollNum) {//滚动
            [self setDataScroll:YES complete:^{
                weakself.recordNums = weakself.currentNums;
                weakself.isAnimation = NO;
                if (weakself.emptyNum) {
                    [weakself startAnimationWithNumbers:weakself.emptyNum];
                }
                else {
                    if (weakself.scrollAnimationComplete) {
                        weakself.scrollAnimationComplete();
                    }
                }
            }];
        }
        else {//缩放
            [self setDataScroll:NO complete:^{
                
            }];
            [self sacaleAnimation:^{
                weakself.recordNums = weakself.currentNums;
                weakself.isAnimation = NO;
                if (weakself.emptyNum) {
                    [weakself startAnimationWithNumbers:weakself.emptyNum];
                }
                else {
                    if (weakself.scrollAnimationComplete) {
                        weakself.scrollAnimationComplete();
                    }
                }
            }];
        }
    }
    
}

- (void)setDataScroll:(BOOL)animation complete:(void(^)(void))complete {
    NSString *currentStr = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.currentNums]];
    NSString *recordStr = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.recordNums]];
    NSInteger newBit = currentStr.length - recordStr.length;
    for (int i = 0; i < newBit; i++) {
        recordStr = [recordStr stringByAppendingString:@"0"];//对齐长度
    }
    for (int i = 0; i < currentStr.length; i++) {
        int from = [[recordStr substringWithRange:NSMakeRange(i, 1)] intValue];
        int to = [[currentStr substringWithRange:NSMakeRange(i, 1)] intValue];
        CGFloat offset = 0;
        if (from > to) {
            offset = to + 10 - from;
        }
        else if (from < to) {
            offset = to - from;
        }
        else {
            continue;
        }
        UIScrollView *scrollView = self.bitLayerArray[i];
        if (animation) {
            [UIView animateWithDuration:self.scrollDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [scrollView setContentOffset:CGPointMake(0, offset * self->_itemSize.height + scrollView.contentOffset.y)];
            } completion:^(BOOL finished) {
                if (scrollView.contentOffset.y >= 10 * self->_itemSize.height) {
                    [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y - 10 * self->_itemSize.height) animated:NO];
                }
            }];
        }
        else {
            [scrollView setContentOffset:CGPointMake(0, offset * _itemSize.height + scrollView.contentOffset.y) animated:animation];
            if (scrollView.contentOffset.y >= 10 * _itemSize.height) {
                [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y - 10 * _itemSize.height) animated:NO];
            }
        }
    }
    if (animation) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.scrollDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (complete) {
                complete();
            }
        });
    }
    else {
        if (complete) {
            complete();
        }
    }
}

- (void)sacaleAnimation:(void(^)(void))complete {
    [UIView animateKeyframesWithDuration:self.scaleDuration delay:0 options:0 animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:self.scaleDuration / 2 animations:^{
            self.transform = CGAffineTransformMakeScale(2.0, 2.5);
        }];
        [UIView addKeyframeWithRelativeStartTime:self.scaleDuration / 2 relativeDuration:self.scaleDuration / 2 animations:^{
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:self.scaleDuration - 0.01 relativeDuration:0.01 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

- (NSMutableArray *)bitLayerArray {
    if (!_bitLayerArray) {
        _bitLayerArray = [NSMutableArray array];
    }
    return _bitLayerArray;
}
@end
