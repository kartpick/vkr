//
//  AGGameScene.h
//  Game
//
//  Created by Artem Egorov on 07.09.15.
//  Copyright (c) 2015 Aximedia Soft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AGGameScene : SKScene <SKPhysicsContactDelegate>
@property CGFloat HERO_RUNNING_SPEED;
@end
