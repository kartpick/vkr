//
//  GameViewController.m
//  Game
//
//  Created by Artem Egorov on 07.09.15.
//  Copyright (c) 2015 Aximedia Soft. All rights reserved.
//

#import "GameViewController.h"
#import "AGGameScene.h"


@implementation SKScene (Unarchive)

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount = YES;
    
    NSLog(@"width %fl", skView.bounds.size.width);
    NSLog(@"height %fl", skView.bounds.size.height);
    
    AGGameScene *gameScene = [[AGGameScene alloc] initWithSize:skView.bounds.size];
    gameScene.scaleMode = SKSceneScaleModeAspectFit;
    [gameScene setAnchorPoint:CGPointMake(0, 0)];
    
    
    [skView presentScene:gameScene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
