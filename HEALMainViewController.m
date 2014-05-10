//
//  HEALMainViewController.m
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALMainViewController.h"
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface HEALMainViewController ()
{
    NSTimer* uiUpdateTimer;
    BOOL slidRight;
    UIGestureRecognizer *tapRecognizer;
    UIButton* circleStateButton;
    
    int smsInt;
    NSTimer* smsTimer;
    BOOL sendAutoMessage;
    UIAlertView* autoView;
    UIButton* envelopeButton;
}

@end

@implementation HEALMainViewController

//############################################ Constants ############################################
static int const RIGHTVIEW_SETTINGS_BUTTON_TAG = 0;
static int const RIGHTVIEW_SMS_BUTTON_TAG = 1;
static int const RIGHTVIEW_NIGHT_BUTTON_TAG = 2;
static int const RIGHTVIEW_SMS_SETTINGS_BUTTON_TAG = 3;
static int const RIGHTVIEW_BAC_DISCLAIMER_BUTTON_TAG = 4;
static float const STANDARD_PAN_DURATION = 0.1;



//########################################## Setup Views, Buttons, Gestures and Timer ############################################

- (void)viewDidLoad
{
    [self.timeLabel setFont:[UIFont fontWithName:@"Cambria" size: 20]];
    
    
    //###cant set button text the same as labels. working on it
    //[[_settingsButton.titleLabel setFont:[UIFont fontWithName:@"Cambria" size: 20] ];



    [self setupUI];
}

// Checks to see that a user object exists and sets the navbar's appearance.
- (void)viewWillAppear:(BOOL)animated
{
    // If no user object exists, sends the user to the edit settings screen.
    if (!self.user) {
        [self performSegueWithIdentifier:@"settingsMainSegue" sender:self];
    }
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"sampleNavBar1.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

// initializes all UI elements. Right now it only gets called from viewDidLoad. Calls all other setup methods
- (void)setupUI
{
    [self setupBackgroundImages];
    [self setupRightViewButtons];
    [self setupCenterViewButtons];
    [self setupGestures];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    [self newNight];
    [self.view sendSubviewToBack:self.rightView];
    
    slidRight = NO;
}

// sets the background images for the parentview, centerview and rightview
- (void)setupBackgroundImages
{
    self.backgroundImageView.image = [UIImage imageNamed:@"purple1.png"];
    self.centerView.image = [UIImage imageNamed:(@"empty.png")];
    self.rightView.image = [UIImage imageNamed:(@"purple1.png")];
}

// sets up all the centerviewbuttons
- (void)setupCenterViewButtons
{
    [self setupCircleButton];
    [self envelopeButton];
    envelopeButton.hidden = YES;
    envelopeButton.UserInteractionEnabled = NO;
}

// initializes tag values for the rightviewbuttons to identify them
- (void)setupRightViewButtons
{
    self.settingsButton.tag = RIGHTVIEW_SETTINGS_BUTTON_TAG;
    self.smsButton.tag = RIGHTVIEW_SMS_BUTTON_TAG;
    self.nightButton.tag = RIGHTVIEW_NIGHT_BUTTON_TAG;
    self.smsSettingsButton.tag = RIGHTVIEW_SMS_SETTINGS_BUTTON_TAG;
    self.bacDisclaimerButton.tag = RIGHTVIEW_BAC_DISCLAIMER_BUTTON_TAG;

}

// sets up the panning gesture to move the centerview and the tapping gesture to move back from the rightview
- (void)setupGestures {
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panViews:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	[self.view addGestureRecognizer:panRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerViewTapped)];
    [self.centerView addGestureRecognizer:tapRecognizer];
}

// Creates circle button that shows the states
- (void)setupCircleButton
{
    if (IS_WIDESCREEN) {
        self.longScreenButton.hidden = NO;
        self.longScreenButton.userInteractionEnabled = YES;
        
        self.shortScreenButton.hidden = YES;
        self.shortScreenButton.userInteractionEnabled = NO;
        circleStateButton = self.longScreenButton;
    } else {
        self.shortScreenButton.hidden = NO;
        self.shortScreenButton.userInteractionEnabled = YES;
        
        self.longScreenButton.hidden = YES;
        self.longScreenButton.userInteractionEnabled = NO;
        circleStateButton = self.shortScreenButton;
    }
}

// Updates the circle button based on users current state. Also enables the envelope button.
- (void)updateCircleButton
{
    envelopeButton.hidden = YES;
    envelopeButton.UserInteractionEnabled = NO;
    
    [circleStateButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Button.png", self.user.stateAsString]] forState:UIControlStateNormal];
    
    if (self.user.state == INTOXSTATE_DANGER) {
        envelopeButton.hidden = NO;
        envelopeButton.UserInteractionEnabled = YES;
        
        [circleStateButton setImage:[UIImage imageNamed:@"PlainDangerButton.png"] forState:UIControlStateNormal];
    }
}

// Updates labels according to BAC values
- (void)updateUI
{
    self.drinkStepper.value = self.user.currentNight.drinks;
    [self setDateLabel:[NSDate dateWithTimeIntervalSince1970:self.user.currentNight.startTime]];
    
    [self updateRoundProgressBar];
    [self updateCircleButton];
}

// Creates an envelope button, used to send SMS messages
- (void)envelopeButton
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screen.size.width;
    CGFloat screenHeight = screen.size.height;
    envelopeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [envelopeButton addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    [envelopeButton setImage:[UIImage imageNamed:@"SMSEnvelope.png"] forState:UIControlStateNormal];
    envelopeButton.frame = CGRectMake((0.353*screenWidth), (0.46*screenHeight), (0.3*screenWidth), (0.2*screenWidth));
    [self.centerView addSubview:envelopeButton];
}

// Sets the label below the circle button
- (void)setDateLabel:(NSDate*)date
{
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"hh:mm a"];
    NSString *t = [dFormatter stringFromDate: date];
    
    if(self.drinkStepper.value == 0) {
        [self.timeLabel setText:@"Ready to Start? Press Below!"];
    } else if (self.drinkStepper.value == 1) {
        [self.timeLabel setText:[NSString stringWithFormat:@"%@%@", @"You've had 1 drink since: ", t]];
    } else {
        [self.timeLabel setText:[NSString stringWithFormat:@"%@%@%@%@", @"You've had ", [NSString stringWithFormat:@"%i", self.user.currentNight.drinks], @" drinks since: ", t]];
    }
    
    
}


// Resets the Timer
- (void)resetTimer
{
    if (!uiUpdateTimer) {
        [uiUpdateTimer invalidate];
        uiUpdateTimer = nil;
    }
    uiUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
}


//############################################ Button and View Responders ############################################

// Toggles to the settings sidebar
- (IBAction)threeLinesButtonClicked:(id)sender
{
    [self toggleRightView];
}

// Is called when the user pans the finger across the screen
- (void)panViews:(id)sender
{
    float centerRightEdgePos = self.centerView.frame.origin.x + self.centerView.frame.size.width;
    float parentRightEdgePos = self.view.frame.origin.x + self.view.frame.size.width;
    float toggleLeftFromPos = self.rightView.frame.origin.x + (0.75 * self.rightView.frame.size.width);
    float toggleRightFromPos = self.rightView.frame.origin.x + (0.25 * self.rightView.frame.size.width);
    
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view]; // The diff point when panning
    
    // Happens when the user lifts the finger from the screen after panning
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        // If the user finishes panning and the centerview has been pulled past more than a quarter of the rightview, either way, we toggle views
        if (!slidRight && (centerRightEdgePos < toggleLeftFromPos)) {
            [self toggleRightView];
        } else if (slidRight && (centerRightEdgePos > toggleRightFromPos)) {
            [self toggleRightView];
        } else {
            [self resetViewPlacement]; // if the user finishes panning and the centerview has not been pulled past more than a quarter of the way, we just let the views go back to where they were before the panning started
        }
	}
    
    // Happens when the user first starts the panning gesture
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {

        // If the panning is begun when the centerview is slid over and the movement is going right, or if the centerview is is in the center and the movement is going left, we want the centerview to track the user's finger movement
        if (-self.rightView.frame.size.width == self.centerView.frame.origin.x && translatedPoint.x > 0){
            self.centerView.center = CGPointMake(self.centerView.center.x + translatedPoint.x, self.centerView.center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        } else if (centerRightEdgePos == parentRightEdgePos && translatedPoint.x < 0){
            self.centerView.center = CGPointMake(self.centerView.center.x + translatedPoint.x, self.centerView.center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        }
    }
    
    // Happens when the user has moved their finger at all
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        // If the centerview is within the right boundaries, we want it's x position to track the user's finger
        if ((-self.rightView.frame.size.width < self.centerView.frame.origin.x) && (centerRightEdgePos < parentRightEdgePos)) {
            self.centerView.center = CGPointMake(self.centerView.center.x + translatedPoint.x, self.centerView.center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        }
	}
}

// Toggles away from the settings sidebar when the main screen is clicked
- (void)centerViewTapped
{
    if(slidRight) [self toggleRightView];
}

// Called when we want to toggle the centerview's position to the opposite default position
- (void)toggleRightView
{
    CGRect frame = self.centerView.frame;
    
    if (slidRight) {
        frame.origin.x = 0;
        slidRight = NO;
    } else if (!slidRight) {
        frame.origin.x = -self.rightView.frame.size.width;
        slidRight = YES;
    }
    
    [UIView animateWithDuration:STANDARD_PAN_DURATION animations:^{
        self.centerView.frame = frame;
    }];
    [circleStateButton setUserInteractionEnabled:!slidRight];
    [self.addButton setUserInteractionEnabled:!slidRight];
}

// Basically just resets the centerview's placement to the standard place corresponding to slidright and not slidright
- (void)resetViewPlacement
{
    CGRect frame = self.centerView.frame;
    
    if (slidRight) {
        frame.origin.x = -self.rightView.frame.size.width;
    } else if (!slidRight) {
        frame.origin.x = 0;
    }
    
    [UIView animateWithDuration:STANDARD_PAN_DURATION animations:^{
        self.centerView.frame = frame;
    }];
}

// SMS message prompt that appears when autoSMS is not enabled.
- (IBAction)sosDanger:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"SOS SMS" message:[NSString stringWithFormat:@"%@%@%@%@%@", @"Send message '", self.user.smsMessage, @"' to ", self.user.sosContact, @"?"] delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    [alertView show];
}

// SMS message prompt that appears when no SOS contact has been specified.
- (IBAction)sosSetup
{
    UIAlertView *setupView = [[UIAlertView alloc]initWithTitle:@"Whoops!" message:@"Looks like you haven't set your SMS settings! Use the envelope button to send an SMS anyway." delegate: self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [setupView show];
}

// Counts down from a value specified in sosAuto and attempts to send an SMS messaage when the countdown ends if cancel
// hasn't been pressed.
-(void)countDownDuration
{
    smsInt -= 1;
    if (smsInt == 1) {
        if (smsTimer != nil) {
            [smsTimer invalidate];
            smsTimer = nil;
        }
        [autoView dismissWithClickedButtonIndex:[autoView cancelButtonIndex] animated:TRUE];
        
        if (sendAutoMessage) {
            [self sendSMS];
            self.user.currentNight.sosSent = TRUE;
        }
        
    }
}

// SMS message prompt that appears when autoSMS is enabled. Also sets countdown time.
- (IBAction)sosAuto:(id)sender
{
    sendAutoMessage = TRUE;
    smsInt = 6;
    smsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownDuration) userInfo:nil repeats:YES];
    autoView = [[UIAlertView alloc]initWithTitle:@"SOS SMS" message:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", @"Message '", self.user.smsMessage, @"' will be sent to ", self.user.sosContact, @" in ", [NSString stringWithFormat:@"%i", smsInt], @" seconds. Cancel?"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [autoView show];
}

// Sets what different buttons in the various alertviews do.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self sendSMS];
        self.user.currentNight.sosSent = TRUE;
    } if (buttonIndex == [alertView cancelButtonIndex]) {
        sendAutoMessage = FALSE;
        smsTimer = nil;
        [smsTimer invalidate];
    }
}

//action when add drink is clicked (THIS NEEDS TO HAVE ITS NAME CHANGED)
- (IBAction)runAddValueChanged:(id)sender
{
    self.drinkStepper.value += 1;
    [self valueChanged:_drinkStepper];
    [self updateRoundProgressBar];
    
    if (self.user.state >= self.user.smsState ) {
        if (!self.user.currentNight.sosSent) {
            if (self.user.sosContact == nil || [self.user.sosContact  isEqualToString:@""] || [self.user.sosContact  isEqualToString:@"Emergency contact Name"]) {
                [self sosSetup];
            } else if(!self.user.autoSMS) {
                [self sosDanger:self];
            } else {
                [self sosAuto:self];
            }
        }
    }
}

// Updates the fill of the round progress bar and changes its color.
- (void)updateRoundProgressBar
{
    self.roundProgressView.progress = self.user.wheelFill;
    self.roundProgressView.tintColor = self.user.wheelColorTint;
}

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
- (IBAction)valueChanged:(UIStepper *)sender
{
    if (self.user.weight == 0) {
        [self alertUser:@"Please enter weight in settings."];
        sender.value = 0;
    } else {
        if (self.user.currentNight.drinks == 0) {
            [self resetTimer];
            NSDate *cTime = [NSDate date];
            self.user.currentNight.startTime = [cTime timeIntervalSince1970];
        }
        self.user.currentNight.drinks = [sender value];
        [self updateUI];
    }
}

// Handles what happens when buttons are clicked in the settings sidebar.
- (IBAction)rightViewButtonClicked:(id)sender {
    UIButton* senderButton = (UIButton*) sender;
    
    if (senderButton.tag == self.settingsButton.tag) {
        [self performSegueWithIdentifier:@"settingsMainSegue" sender:sender];
        [self toggleRightView];
    } else if (senderButton.tag == self.smsButton.tag) {
        [self sendSMS];
    } else if (senderButton.tag == self.nightButton.tag) {
        [self newNight];
        [self toggleRightView];
    } else if (senderButton.tag == self.smsSettingsButton.tag) {
        [self performSegueWithIdentifier:@"toSMSSettingsViewController" sender:sender];
        [self toggleRightView];
    } else if (senderButton.tag == self.bacDisclaimerButton.tag) {
        [self performSegueWithIdentifier:@"bacSegue" sender:sender];
        [self toggleRightView];}
}

// Handles what happens when the center button is clicked.
- (IBAction)centerCircleButtonClick:(id)sender
{
    [self performSegueWithIdentifier:@"toStateViewController" sender:self];
}


//############################################ Segue Related Methods ############################################

//called when another viewController exits to mainViewController
- (IBAction)unwindToMain:(UIStoryboardSegue *)segue
{
    slidRight = NO;
    [self updateUI];
}

//handles segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toStateViewController"]) {
        HEALDrunkStateViewController *controller = [segue destinationViewController];
        controller.user = self.user;
    } else if ([segue.identifier isEqualToString:@"settingsMainSegue"]) {
        HEALEditSettingsViewController *controller = [segue destinationViewController];
        controller.user = self.user;
    } else if ([segue.identifier isEqualToString:@"toSMSSettingsViewController"]) {
        HEALEditSMSSettingsViewController *controller = [segue destinationViewController];
        controller.user = self.user;
    } else if ([segue.identifier isEqualToString:@"bacSegue"]) {
        HEALBacDisclaimerViewController *controller = [segue destinationViewController];
        controller.user = self.user;
    }
}

//############################################ Other Methods for Abstractions etc. ############################################

//creates new night
- (void)newNight
{
    [self resetTimer];
    [self.user.currentNight reset];

    [self updateUI];
    envelopeButton.hidden = YES;
    envelopeButton.UserInteractionEnabled = NO;
    self.roundProgressView.progress = 0;
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
- (void)sendSMS
{
    self.user.currentNight.sosSent = TRUE;
    
    MFMessageComposeViewController *textComposer = [[MFMessageComposeViewController alloc] init];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"sampleNavBar1.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [textComposer setMessageComposeDelegate:self];
    [textComposer.navigationBar setBackgroundImage:[UIImage imageNamed:nil] forBarMetrics:UIBarMetricsDefault];
    [textComposer.navigationBar setTintColor:[UIColor blueColor]];
    
    //if text messages can be sent
    if ([MFMessageComposeViewController canSendText]){
        [self toggleRightView];
        NSArray *recipients = @[self.user.contactNumber];
        [textComposer setRecipients:recipients];
        [textComposer setBody:self.user.smsMessage];
        [self presentViewController:textComposer animated:YES completion:nil];
    } else { //simulator will not allow text messages to be sent
        NSLog(@"Cannot Open Text.");
    }

}

//for dismissing text messaging in app if we cancel or send it
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end