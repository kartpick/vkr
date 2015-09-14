//
//  AGGameScene.m
//  Game
//
//  Created by Artem Egorov on 07.09.15.
//  Copyright (c) 2015 Aximedia Soft. All rights reserved.
//

#import "AGGameScene.h"
#import "AGHeroSprite.h"
#import "AGBackgroundSprite.h"

#pragma mark - Custom Type Definitions


// Obstacles properties
#define kObstacleName @"Obstacle"
#define OBSCTACLE_GEN_DURATION 0.45f
#define OBSCTACLE_GEN_RANGE 1.0f

#pragma mark - Private GameScene Properties

@interface AGGameScene ()
@property BOOL contentCreated;
@property (strong) CMMotionManager* motionManager;
@property (strong) AGHeroSprite *hero;
@property CGSize backgroundSize;
@property CGFloat SwipeBoost;

@property CFTimeInterval timeOfLastUpdate;

@end


#pragma mark - Object Lifecycle Management

@implementation AGGameScene

#pragma mark - Scene Setup and Content Creation

-(void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        [self createContent];
        self.contentCreated = YES;
        
        self.motionManager = [[CMMotionManager alloc] init];
        [self.motionManager startAccelerometerUpdates];
    }
}

- (void)createContent {
    self.backgroundColor = [SKColor brownColor];
    [self generateBackground];
    [self newHero];
    
    self.HERO_RUNNING_SPEED = _hero.actualSpeed;
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [[self view] addGestureRecognizer:recognizer];
}

- (void)newHero {
    _hero = [[AGHeroSprite alloc] init];
    _hero.position = CGPointMake(CGRectGetMidX(self.frame), [AGHeroSprite getHeroHeight]);
    [_hero walkingHero];
    [self addChild:_hero];
}

- (void)addObstacle {
    SKSpriteNode *obstacle = [[SKSpriteNode alloc] initWithImageNamed:@"forest_tree"];
    obstacle.position = CGPointMake(skRand(0, self.size.width), self.size.height + obstacle.size.height);
    obstacle.zPosition = 1;
    obstacle.name = kObstacleName;
    
    obstacle.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:obstacle];
}

- (void)generateBackground {
    _backgroundSize = [AGBackgroundSprite getBackgroundSpriteSize];
    NSInteger xImagesValue = self.size.width / _backgroundSize.width;
    NSInteger yImagesValue = self.size.height / _backgroundSize.height;
    for (int i = 0; i < xImagesValue; i++) {
        for (int j = 0; j < yImagesValue; j++) {
            AGBackgroundSprite *node = [[AGBackgroundSprite alloc] init];
            node.name = @"Background";
            node.position = CGPointMake(i * _backgroundSize.width, j * _backgroundSize.height);
            
            if (j < yImagesValue - 1)
                node.topChunkGenerated = YES;
            else
                node.leftChunkGenerated = NO;

            [self addChild:node];
        }
    }
}

#pragma mark - Scene Update Helpers

static inline CGFloat skRandf(){
    return arc4random() / (CGFloat) RAND_MAX;
}
static inline CGFloat skRand(CGFloat low, CGFloat high){
    return skRandf() * (high - low) + low;
}

#pragma mark Hero Movement Helpers

#pragma mark Obstacles Movement Helpers

- (void)moveObstaclesForUpdate:(NSTimeInterval)currentTime {
    [self enumerateChildNodesWithName:kObstacleName usingBlock:^(SKNode *node, BOOL *stop) {
        
        CMAccelerometerData* data = self.motionManager.accelerometerData;
        if (fabs(data.acceleration.x) > 0.2) {
            if (data.acceleration.x < 0)
                [_hero walkingHeroLeft];
            else
                [_hero walkingHeroRight];
            
            SKAction *moveDown = [SKAction moveTo:CGPointMake(node.position.x - data.acceleration.x * _HERO_RUNNING_SPEED, node.position.y-_HERO_RUNNING_SPEED) duration:0];
            [node runAction:moveDown];
        }
        else {
            [_hero walkingHero];
            SKAction *moveDown = [SKAction moveTo:CGPointMake(node.position.x, node.position.y-_HERO_RUNNING_SPEED) duration:0];
            [node runAction:moveDown withKey:@"moveObstacleDown"];
        }
    }];
}

#pragma mark User Tap & Swipe Helpers

- (void) handleSwipe: (UISwipeGestureRecognizer *)sender {
    if (_HERO_RUNNING_SPEED < 15 & _HERO_RUNNING_SPEED + _SwipeBoost < 15)
        _SwipeBoost += 0.5;
}

#pragma mark HUD Helpers

#pragma mark Scene Update

- (void)update:(CFTimeInterval)currentTime {
    [self moveObstaclesForUpdate:currentTime];
    [self generateBackgroundForUpdate:currentTime];
    [self moveBackgroundForUpdate:currentTime];
    [self updateObstaclesGenerationWithTime:currentTime];
}

- (void)didFinishUpdate {
    if (_SwipeBoost != 0) {
        _HERO_RUNNING_SPEED += _SwipeBoost;
        _SwipeBoost = 0;
    }
    if (_HERO_RUNNING_SPEED > 1) {
        _HERO_RUNNING_SPEED -= 0.05f;
    }
}

- (void)generateBackgroundForUpdate: (CFTimeInterval)currentTime {
    [self enumerateChildNodesWithName:@"Background" usingBlock:^(SKNode *node, BOOL *stop) {
        AGBackgroundSprite *sprite = (AGBackgroundSprite *)node;
        BOOL leftBackground = NO;
        BOOL rightBackground = NO;
        
        for (SKSpriteNode *rightNode in [self nodesAtPoint:CGPointMake(sprite.position.x + _backgroundSize.width, sprite.position.y)])
            if ([rightNode.name isEqual:@"Background"]) {
                rightBackground = YES;
                break;
            }
        
        for (SKSpriteNode *leftNode in [self nodesAtPoint:CGPointMake(sprite.position.x - _backgroundSize.width, sprite.position.y)])
            if ([leftNode.name isEqual:@"Background"]) {
                leftBackground = YES;
                break;
            }
        
        
        // ----- Генерация новых объектов -----
        if (sprite.topChunkGenerated == NO && sprite.position.y <= self.size.height) {
            sprite.topChunkGenerated = YES;
            
            AGBackgroundSprite *nodeToAdd = [[AGBackgroundSprite alloc] init];
            
            // настройка базовых параметров
            nodeToAdd.topChunkGenerated = NO;
            nodeToAdd.name = @"Background";
            nodeToAdd.zPosition = -1;
            nodeToAdd.position = CGPointMake(node.position.x,node.position.y + _backgroundSize.height);
            
            [self addChild:nodeToAdd];
        }
        
        if (sprite.position.x >= 0 && leftBackground == NO) {
            
            AGBackgroundSprite *nodeToAdd = [[AGBackgroundSprite alloc] init];
            
            nodeToAdd.name = @"Background";
            nodeToAdd.topChunkGenerated = sprite.topChunkGenerated;
            nodeToAdd.zPosition = -1;
            nodeToAdd.position = CGPointMake(sprite.position.x - _backgroundSize.width,sprite.position.y);
            
            [self addChild:nodeToAdd];
        }
        else if (sprite.position.x <= self.size.width && sprite.position.x >= self.size.width - _backgroundSize.width * 2 && rightBackground == NO) {
            
            AGBackgroundSprite *nodeToAdd = [[AGBackgroundSprite alloc] init];
            
            nodeToAdd.name = @"Background";
            nodeToAdd.topChunkGenerated = sprite.topChunkGenerated;
            nodeToAdd.zPosition = -1;
            nodeToAdd.position = CGPointMake(sprite.position.x + _backgroundSize.width,sprite.position.y);
            
            [self addChild:nodeToAdd];
        }
    }];
}

- (void)updateObstaclesGenerationWithTime: (CFTimeInterval)currentTime {
    if (currentTime - self.timeOfLastUpdate < OBSCTACLE_GEN_DURATION) return;
    
    
    [self removeAllActions];
    
    SKAction *makeObstacles = [SKAction performSelector:@selector(addObstacle) onTarget:self];
    
    [self runAction:makeObstacles];
    self.timeOfLastUpdate = currentTime;
}

- (void)moveBackgroundForUpdate: (CFTimeInterval)currentTime {
    [self enumerateChildNodesWithName:@"Background" usingBlock:^(SKNode *node, BOOL *stop) {
        
        CMAccelerometerData* data = self.motionManager.accelerometerData;
        
        // ----- Обработка акселерации -----
        if (fabs(data.acceleration.x) > 0.2)
            [node runAction:[SKAction moveTo:CGPointMake(node.position.x - data.acceleration.x * _HERO_RUNNING_SPEED, node.position.y-_HERO_RUNNING_SPEED) duration:0] withKey:@"movebackground"];
        else
            [node runAction:[SKAction moveTo:CGPointMake(node.position.x, node.position.y - _HERO_RUNNING_SPEED) duration:0] withKey:@"movebackground"];
    }];
}

#pragma mark Physics Contact Helpers

- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:kObstacleName usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"Background" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y + node.frame.size.height < 0)
            [node removeFromParent];
        else if (node.position.x < -_backgroundSize.width * 2)
            [node removeFromParent];
        else if (node.position.x > self.size.width + _backgroundSize.width * 2)
            [node removeFromParent];
    }];
}

#pragma mark Game End Helpers

@end
