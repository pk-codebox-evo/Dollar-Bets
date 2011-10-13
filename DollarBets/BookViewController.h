//
//  BookViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 8/22/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opponent.h"


@class BookFrontView;
@class BookSettingsView;
@class BookViewController;
@class Opponent;

@protocol BookViewControllerDelegate <NSObject>
-(void)opponentCreatedWithName:(NSString *)oppName by:(BookViewController *)book;
-(void)deleteThisBook:(BookViewController *)book;
-(void)didSelectBook:(BookViewController *)book;
@end


@interface BookViewController : UIViewController <UIGestureRecognizerDelegate, UITextFieldDelegate> {

    bool frontViewIsVisible;
    UILabel * debugLabel;
    
    UIView *containerView;	
    BookFrontView *frontView;
    BookSettingsView *backView;


}
@property (assign)BOOL frontViewIsVisible;
@property (strong, nonatomic)Opponent *opponent;
@property (strong, nonatomic)UIView *containerView;
@property (strong, nonatomic)BookFrontView *frontView;
@property (strong, nonatomic)BookSettingsView *backView;
@property (strong, nonatomic)UILabel *debugLabel;
@property (assign)id delegate;


-(id)initWithOpponent:(Opponent *)opp;

-(void)configButtonSelected:(id)sender;
-(void)backButtonSelected:(id)sender;
-(void)deleteButtonSelected:(id)sender;

-(void)didDoubleClick;

-(void)flipCurrentView;
-(void)refreshFrontView;



@end
