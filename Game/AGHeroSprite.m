//
//  AGHeroSprite.m
//  Game
//
//  Created by Artem Egorov on 07.09.15.
//  Copyright (c) 2015 Aximedia Soft. All rights reserved.
//

#import "AGHeroSprite.h"

// Hero properties
#define kHeroSize CGSizeMake(16, 32)
#define kheroName @"Hero"
#define kHeroTextureWalkKey @"walkingHero"
#define kHeroTextureWalkLeftKey @"walkingHeroLeft"
#define kHeroTextureWalkRightKey @"walkingHeroRight"
#define kHeroFrameColor [SKColor greenColor]
#define kHeroHeightPosition 200.f
#define kHeroDefaultSpeed 1.f

@interface AGHeroSprite ()
@property NSMutableArray *walkFrames;
@property NSMutableArray *walkLeftFrames;
@property NSMutableArray *walkRightFrames;
@property SKTextureAtlas *heroAnimatedAtlas;
@property NSString *runningPosition;

@end

@implementation AGHeroSprite

- (id)init {
    if (self = [super init]) {
        self = [[AGHeroSprite alloc] initWithColor:kHeroFrameColor size:kHeroSize];
        [self setUpHeroDetails];
    }
    return self;
}

- (void)setUpHeroDetails {
    self.name = kheroName;
    self.actualSpeed = kHeroDefaultSpeed;
    
    _walkFrames = [NSMutableArray array];
    _walkLeftFrames = [NSMutableArray array];
    _walkRightFrames = [NSMutableArray array];
    _heroAnimatedAtlas = [SKTextureAtlas atlasNamed:@"GameHeroImages"];
    
    NSInteger numImages = _heroAnimatedAtlas.textureNames.count;
    
    for (int i = 1; i <= numImages / 3; i++) {
        NSString *textureNameWalk = [NSString stringWithFormat:@"hero_walk_%d", i];
        NSString *textureNameWalkLeft = [NSString stringWithFormat:@"hero_walk_left_%d", i];
        NSString *textureNameWalkRight = [NSString stringWithFormat:@"hero_walk_right_%d", i];
        
        SKTexture *temp = [_heroAnimatedAtlas textureNamed:textureNameWalk];
        [_walkFrames addObject:temp];
        
        temp = [_heroAnimatedAtlas textureNamed:textureNameWalkLeft];
        [_walkLeftFrames addObject:temp];
        
        temp = [_heroAnimatedAtlas textureNamed:textureNameWalkRight];
        [_walkRightFrames addObject:temp];
    }
    _runningPosition = kHeroTextureWalkKey;
}

- (void)walkingHero {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [self runAction:[SKAction repeatActionForever:
                         [SKAction animateWithTextures:_walkFrames timePerFrame:0.1f resize:NO restore:YES]] withKey:kHeroTextureWalkKey];
    });
    
    if (![_runningPosition  isEqual: kHeroTextureWalkKey]) {
        [self runAction:[SKAction repeatActionForever:
                         [SKAction animateWithTextures:_walkFrames timePerFrame:0.1f resize:NO restore:YES]] withKey:kHeroTextureWalkKey];
        _runningPosition = kHeroTextureWalkKey;
    }
}

- (void)walkingHeroLeft {
    if (![_runningPosition isEqual: kHeroTextureWalkLeftKey]) {
        [self runAction:[SKAction repeatActionForever:
                         [SKAction animateWithTextures:_walkLeftFrames timePerFrame:0.1f resize:NO restore:YES]] withKey:kHeroTextureWalkKey];
        _runningPosition = kHeroTextureWalkLeftKey;
    }
}

- (void)walkingHeroRight {
    if (![_runningPosition isEqual: kHeroTextureWalkRightKey]) {
        [self runAction:[SKAction repeatActionForever:
                         [SKAction animateWithTextures:_walkRightFrames timePerFrame:0.1f resize:NO restore:YES]] withKey:kHeroTextureWalkKey];
        _runningPosition = kHeroTextureWalkRightKey;
    }
}

+ (CGFloat)getHeroHeight {
    return kHeroHeightPosition;
}

@end
