#import "UIView+FLXNode.h"

#import "FLXNode.h"

#import "FLXView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FLXView

#pragma mark - UIView+FLXNode

- (FLXNode *)flx_generateTree {
    FLXNode *node = [super flx_generateTree];

    node.childAlignment = self.childAlignment;

    NSMutableArray *children = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView *subview in self.subviews) {
        [children addObject:[subview flx_generateTree]];
    }
    node.children = children;

    node.direction = self.direction;
    node.justification = self.justification;
    node.origin = CGPointZero;
    node.padding = self.padding;
    node.wrap = self.wrap;

    return node;
}

#pragma mark - UIView

- (CGSize)sizeThatFits:(CGSize)size {
    FLXNode *node = [self flx_generateTree];
    node.size = CGSizeMake(size.width, NAN);

    [node layoutWithMaxWidth:size.width];

    return node.size;
}

- (void)layoutSubviews {
    FLXNode *node = [self flx_generateTree];
    node.size = self.bounds.size;

    [node layoutWithMaxWidth:self.bounds.size.width];

    for (FLXNode *subnode in node.children) {
        CGRect frame = {
            .origin = subnode.origin,
            .size = subnode.size
        };

        subnode.view.frame = CGRectIntegral(frame);
    }
}

@end

NS_ASSUME_NONNULL_END
