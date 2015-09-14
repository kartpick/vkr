//
//  AGBackgroundSprite.h
//  Game
//
//  Created by Artem Egorov on 08.09.15.
//  Copyright (c) 2015 Aximedia Soft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AGBackgroundSprite : SKSpriteNode
@property NSArray *imagesArray;
@property BOOL topChunkGenerated;
@property BOOL leftChunkGenerated;
@property BOOL rightChunkGenerated;

@property AGBackgroundSprite *leftChunk;
@property AGBackgroundSprite *rightChunk;
+ (CGSize)getBackgroundSpriteSize;

@end
