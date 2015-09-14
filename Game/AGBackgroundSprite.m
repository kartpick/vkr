//
//  AGBackgroundSprite.m
//  Game
//
//  Created by Artem Egorov on 08.09.15.
//  Copyright (c) 2015 Aximedia Soft. All rights reserved.
//

#import "AGBackgroundSprite.h"

#define kSpriteSize CGSizeMake(128, 128)

@implementation AGBackgroundSprite


+ (CGSize)getBackgroundSpriteSize {
    return kSpriteSize;
}

- (id)init {
    if (self = [super init]) {
        _imagesArray = @[@"forest_tiles", @"forest_tiles_2"];
        NSInteger imageNumerator = (NSInteger) skRand(0, _imagesArray.count - 1);
        
        self = [[AGBackgroundSprite alloc] initWithImageNamed:[_imagesArray objectAtIndex:imageNumerator]];
        self.topChunkGenerated = NO;
        self.size = kSpriteSize;
    }
    return self;
}

#pragma mark - Random Helpers

static inline CGFloat skRandf(){
    return arc4random() / (CGFloat) RAND_MAX;
}
static inline CGFloat skRand(CGFloat low, CGFloat high){
    return skRandf() * (high - low) + low;
}

@end
