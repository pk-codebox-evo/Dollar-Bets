//
//  BookViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 8/22/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BookViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "Opponent.h"
#import "BookFrontView.h"
#import "BookSettingsView.h"

@interface BookViewController(PrivateMethods)
-(void)setupDebugLabel;
@end    

@implementation BookViewController
@synthesize frontView, backView;
@synthesize delegate;
@synthesize opponent;
@synthesize containerView;

@synthesize debugLabel;

-(id)initWithOpponent:(Opponent *)opp
{
    if (self = [super init])
    {
        [self setFrontView:nil];
        [self setBackView:nil];
        [self setContainerView:nil];
        [self setOpponent:nil];
        self.opponent = opp;
    }    
    return self;
}


-(void)setupDebugLabel
{
    /*  --------DEBUG LABEL---------*/
    UILabel *dl = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 320, 30)];
    dl.font = [UIFont fontWithName:@"STHeitiJ-Light" size:20.0f];
    dl.textAlignment = UITextAlignmentCenter;
    self.debugLabel = dl;
}


#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
  //  self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    /*
    UIView *localContainerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.containerView = localContainerView;
    self.containerView.backgroundColor = [UIColor clearColor];
    */

    /*  --------DEBUG LABEL---------*/
    [self.containerView addSubview:self.debugLabel];
    
    BookFrontView *bfw = [[BookFrontView alloc] initWithFrame:self.view.frame ];
    bfw.viewController = self;
    self.frontView = bfw;
    
    BookSettingsView *bsw = [[BookSettingsView alloc] initWithFrame:self.view.frame];
    bsw.viewController = self;
    bsw.backgroundColor = [UIColor clearColor];
    self.backView = bsw;
    
   // self.view = self.containerView;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.frontView];
    frontViewIsVisible = YES;
}


- (void)viewDidUnload
{
    [self setFrontView:nil];
    [self setBackView:nil];
    [self setContainerView:nil];
    [self setOpponent:nil];
    [super viewDidUnload];
}


/* Button methods */
- (void)configButtonSelected:(id)sender 
{
    [self flipCurrentView];    
}


-(void)backButtonSelected:(id)sender
{
    [self flipCurrentView];
}


-(void)deleteButtonSelected:(id)sender
{
    switch ([sender tag]) {
        case 0:
            [self.backView showPopOver];
            [self.backView.deleteButton setSelected:YES];
            break;
        case 1:
            [self.delegate deleteThisBook:self];
            [self.backView.deleteButton setSelected:NO];
            break;
        default:
            break;
    }
}


-(void)didDoubleClick
{
    [self.delegate didSelectBook:self];
}


-(void)refreshFrontView
{
    [self.frontView refresh];
}


- (void)flipCurrentView 
{
  // disable user interaction during the flip
  self.view.userInteractionEnabled = NO;
  
    
    // swap the views and transition
    if (frontViewIsVisible == YES) 
    {
        [UIView transitionFromView:self.frontView
                            toView:self.backView
                          duration:0.75f
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished){
                        	self.view.userInteractionEnabled = YES;
                        }];
    }
    else
    {
        [UIView transitionFromView:self.backView
                            toView:self.frontView
                          duration:0.75f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                        	self.view.userInteractionEnabled = YES;
                        }];
    }
    
    frontViewIsVisible=!frontViewIsVisible;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!frontViewIsVisible && self.backView.popOver.alpha == 1.0f)
    {
        [self.backView hidePopOver];
        [self.backView.deleteButton setSelected:NO];
    }
}

#pragma mark - TextField Delegate Functions
-(void)textFieldDidBeginEditing:(UITextField *)textField 
{
    self.frontView.nameLabel.alpha = 0.0f;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.frontView.nameLabel.text = textField.text;
    self.frontView.nameLabel.alpha = 1.0f;
    textField.text = @"";
    [textField resignFirstResponder];
    [delegate opponentCreatedWithName:frontView.nameLabel.text by:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
