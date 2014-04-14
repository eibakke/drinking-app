//
//  HEALMainViewController.m
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALMainViewController.h"

@interface HEALMainViewController ()
{
    NSTimer *timer;
    BOOL slidRight;
    UIGestureRecognizer *tapRecognizer;
    UIButton *button;
    UIButton *sosButton;
    CGPoint centerViewCenter;
}
@property (weak, nonatomic) IBOutlet UIButton *nightButton;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *smsSettingsButton;

- (IBAction)rightViewButtonClicked:(id)sender;

@end

@implementation HEALMainViewController

//############################################ Setup Views Buttons Gestures and Timer ############################################
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Flip.png"]]];
    [self setupGestures];
    [self circleButton];
    [self sosButton];
    sosButton.hidden = YES;
    sosButton.UserInteractionEnabled = NO;
    [self updateBackground:@"Sober"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    centerViewCenter.x = self.centerView.frame.size.width / 2;
    [self.view sendSubviewToBack:self.rightView];
    slidRight = NO;
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerViewTapped)];
    [self.centerView addGestureRecognizer:tapRecognizer];
    self.settingsButton.tag = 0;
    self.smsButton.tag = 1;
    self.nightButton.tag = 2;
    self.smsSettingsButton.tag = 3;
}

-(void)setupGestures {
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panViews:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	[self.view addGestureRecognizer:panRecognizer];
}

//creates circle button that shows the states
- (void)circleButton
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"CenterButtonSober.png"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(stateSegue) forControlEvents:UIControlEventTouchUpInside];
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screen.size.width;
    CGFloat screenHeight = screen.size.height;
    button.frame = CGRectMake((0.05*screenWidth), (0.16*screenHeight), (0.9*screenWidth), (0.9*screenWidth));
    button.clipsToBounds = YES;
    
    button.layer.cornerRadius = (0.8*screenWidth)/2.0;
    
    
    [self.centerView addSubview:button];
}

//Updates the background, currently not changing
- (void) backgroundUpdate
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:(@"empty.png")] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.centerView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:(@"Flip.png")] drawInRect:self.view.bounds];
    UIImage *imageBack = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.rightView.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"Flip.png"]] colorWithAlphaComponent:0.0];
}

//updates background programmatically according to drinking state
- (void) updateBackground:(NSString*) State
{
    
    if ([State  isEqual: @"Sober"])
    {
        [self backgroundUpdate];
    }
    
    
    if ([State  isEqual: @"Tipsy"])
    {
        [self backgroundUpdate];
    }
    
    
    if ([State  isEqual: @"Drunk"])
    {
        [self backgroundUpdate];
    }
    
    if ([State  isEqual: @"Danger"])
    {
        [self backgroundUpdate];
    }
    
    if ([State  isEqual: @"Dead"])
    {
        [self backgroundUpdate];
    }
    
}

//updates labels according to BAC values
- (void) updateLabels
{
    self.drinkStepper.value = self.user.currentNight.drinks;
    [self.drinkLabel setText:[NSString stringWithFormat:@"%d", self.user.currentNight.drinks]];
    [self setDateLabel:[NSDate dateWithTimeIntervalSince1970:self.user.currentNight.startTime]];
    [self countUp];
    
    if (self.user.state == DEAD)
    {
        [button setImage:[UIImage imageNamed:@"DangerButton.png"] forState:UIControlStateNormal];
        
    } else if (self.user.state == SOBER)
    {
        [button setImage:[UIImage imageNamed:@"CenterButtonSober.png"] forState:UIControlStateNormal];
        
    } else if(self.user.state == TIPSY)
    {
        [button setImage:[UIImage imageNamed:@"TipsyButton.png"] forState:UIControlStateNormal];
        
    } else if (self.user.state == DRUNK)
    {
        [button setImage:[UIImage imageNamed:@"DrunkButton.png"] forState:UIControlStateNormal];
        
    } else if (self.user.state == DANGER)
    {
        sosButton.hidden = NO;
        sosButton.UserInteractionEnabled = YES;
        
        [button setImage:[UIImage imageNamed:@"DangerButtonSMS.png"] forState:UIControlStateNormal];
        if (self.user.currentNight.sosSent == FALSE)
        {
            [self sosDanger:self];
        }
    }
}

//creates SOS button
- (void)sosButton
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screen.size.width;
    CGFloat screenHeight = screen.size.height;
    sosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sosButton addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    sosButton.frame = CGRectMake((0.05*screenWidth), (0.16*screenHeight + .46*screenWidth), (0.9*screenWidth), (0.45*screenWidth));
    [self.centerView addSubview:sosButton];
}

//sets the date label-'youve been drinking since'
- (void)setDateLabel:(NSDate*)date
{
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"hh:mm a"];
    NSString *t = [dFormatter stringFromDate: date];
    [self.timeLabel setText:[NSString stringWithFormat:@"%@%@", @"You've been drinking since: ", t]];
}

//resets the Timer
- (void)resetTimer
{
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countUp) userInfo:nil repeats:YES];
}


//############################################ Button and View Responders ############################################
//is called from updateLabels, updates the bacLabel
- (void)countUp
{
    [self.bacLabel setText:[NSString stringWithFormat:@"%f", self.user.BAC]];
}

- (IBAction)threeLinesButtonClicked:(id)sender
{
    [self toggleRightView];
}

- (void)panViews:(id)sender
{
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
	CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        if (!slidRight && (centerViewCenter.x - self.centerView.center.x > (self.rightView.frame.size.width / 2))) {
            [self toggleRightView];
        } else if (slidRight && (self.centerView.center.x > (centerViewCenter.x - (self.rightView.frame.size.width / 2)))) {
            [self toggleRightView];
        } else {
            [self resetViewPlacement];
        }
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if (!slidRight && velocity.x <= -2000) {
            [self toggleRightView];
        } else if (slidRight && velocity.x > 2000) {
            [self toggleRightView];
        } else if ((centerViewCenter.x - self.centerView.center.x < self.rightView.frame.size.width) && velocity.x < 0) {
            self.centerView.center = CGPointMake(self.centerView.center.x + translatedPoint.x, self.centerView.center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        } else if ((self.centerView.center.x < centerViewCenter.x) && velocity.x > 0){
            self.centerView.center = CGPointMake(self.centerView.center.x + translatedPoint.x, self.centerView.center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        }
	}
}

- (void)centerViewTapped
{
    if(slidRight) [self toggleRightView];
}

- (void)toggleRightView
{
    CGRect frame = self.centerView.frame;
    
    if(slidRight)
    {
        frame.origin.x = 0;
        slidRight = NO;
    }
    else if(!slidRight)
    {
        frame.origin.x = -self.rightView.frame.size.width + 5;
        slidRight = YES;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.centerView.frame = frame;
    }];
    [self.centerView setUserInteractionEnabled:!slidRight];
}

- (void)resetViewPlacement
{
    CGRect frame = self.centerView.frame;
    
    if(slidRight)
    {
        frame.origin.x = -self.rightView.frame.size.width;
    }
    else if(!slidRight)
    {
        frame.origin.x = 0;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.centerView.frame = frame;
    }];
}

//SMS sending warning message
- (IBAction)sosDanger:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"SOS SMS" message:[NSString stringWithFormat:@"%@%@%@%@%@", @"Send message '", self.user.smsMessage, @"' to ", self.user.sosContact, @"?"] delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self sendSMS];
        self.user.currentNight.sosSent = TRUE;
    }
}

//action when add drink is clicked
- (IBAction)runAddValueChanged:(id)sender
{
    self.drinkStepper.value += 1;
    [self valueChanged:_drinkStepper];
    
    //fills up the progress view bar
    [UIView animateWithDuration:10.0 animations:^{
        if (self.user.state==SOBER){
        self.roundProgressView.progress = self.user.BAC*50;
        self.roundProgressView.tintColor = [UIColor whiteColor];
        
        }
        else if (self.user.state==TIPSY){
            self.roundProgressView.progress = (self.user.BAC-0.02)*25;
            self.roundProgressView.tintColor = [UIColor whiteColor];
        }
        else if (self.user.state==DRUNK){
           /* if(self.user.lastState == TIPSY){
                [UIView animateWithDuration:10.0 animations:^{
                    self.roundProgressView.tintColor = [UIColor blueColor];
                    self.roundProgressView.progress = 1;
                    }];
            }*/
            self.roundProgressView.progress = (self.user.BAC-0.06)*1/0.14;
            self.roundProgressView.tintColor = [UIColor whiteColor];
        }
        else if (self.user.state==DANGER){
            self.roundProgressView.progress = (self.user.BAC-0.2)*1/0.8;
            self.roundProgressView.tintColor = [UIColor whiteColor];
        }
    }];
}

- (IBAction)valueChanged:(UIStepper *)sender
{
    self.user.lastState = self.user.state;
    if(self.user.weight == 0)
    {
        [self alertUser:@"Please enter weight in settings."];
        sender.value = 0;
    } else {
        if (self.user.currentNight.drinks == 0) {
            [self resetTimer];
            [self.user.currentNight resetStartTime];
        }
        self.user.currentNight.drinks = [sender value];
        [self updateLabels];
    }
}

//handles right view buttons when clicked
- (IBAction)rightViewButtonClicked:(id)sender {
    UIButton* senderButton = (UIButton*) sender;
    
    if (senderButton.tag == self.settingsButton.tag) {
        [self performSegueWithIdentifier:@"toSettingsViewController" sender:sender];
        [self toggleRightView];
    }
    else if (senderButton.tag == self.smsButton.tag) {
        [self sendSMS];
    }
    else if (senderButton.tag == self.nightButton.tag) {
        [self newNight];
        [self toggleRightView];
    }
    else if (senderButton.tag == self.smsSettingsButton.tag) {
        [self performSegueWithIdentifier:@"toSMSSettingsViewController" sender:sender];
        [self toggleRightView];
    }
}


//############################################ Segue Related Methods ############################################
//called when another viewController exits to mainViewController
- (IBAction)unwindToMain:(UIStoryboardSegue *)segue
{
    slidRight = NO;
    [self updateLabels];
    
}

//segue to drunkstate view controller
- (void)stateSegue
{
    [self performSegueWithIdentifier:@"toStateViewController" sender:self];
}

//handles segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toStateViewController"])
    {
        HEALDrunkStateViewController *controller = [segue destinationViewController];
        controller.user = self.user;
    } else if([segue.identifier isEqualToString:@"toSettingsViewController"])
    {
        HEALEditSettingsViewController *controller = [segue destinationViewController];
        controller.user = self.user;
    } else if([segue.identifier isEqualToString:@"toSettingsViewController"])
    {
        HEALEditSMSSettingsViewController *controller = [segue destinationViewController];
        controller.user = self.user;
    }
    
}

//############################################ Other Methods for Abstractions etc. ############################################

//creates new night
- (void)newNight
{
    [self resetTimer];
    [self.user.currentNight reset];
    [self updateLabels];
    [self.timeLabel setText:@"Ready to start? Press the plus below!"];
    [self updateBackground:@"Sober"];
    //[self delete:sosButton];
    sosButton.hidden = YES;
    sosButton.UserInteractionEnabled = NO;
    self.roundProgressView.progress =0;
}

//alert Message
- (void)alertUser:(NSString*) alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}



//send SMS
- (void)sendSMS{
    
    MFMessageComposeViewController *textComposer = [[MFMessageComposeViewController alloc] init];
    
    [textComposer setMessageComposeDelegate:self];
    
    if ([MFMessageComposeViewController canSendText]){ //if text messages can be sent
        [textComposer setRecipients:[NSArray arrayWithObjects: nil]]; //allows user to choose number to send text to (replace nil by number to send it to a predetermined number)
        [textComposer setBody:self.user.smsMessage];
        [self presentViewController:textComposer animated:YES completion:NULL];
        
    } else { //simulator will not allow text messages to be sent
        NSLog(@"Cannot Open Text.");
    }
    
}

//for dismissing text messaging in app if we cancel or send it
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end