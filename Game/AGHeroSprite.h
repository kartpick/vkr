//
//  AGHeroSprite.h
//  Game
//
//  Created by Artem Egorov on 07.09.15.
//  Copyright (c) 2015 Aximedia Soft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AGHeroSprite : SKSpriteNode
@property NSString *heroName;
@property CGFloat actualSpeed;
@property BOOL alive;

+ (CGFloat)getHeroHeight;

- (void)walkingHero;
- (void)walkingHeroLeft;
- (void)walkingHeroRight;
@end
