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
    int smsInt;
    NSTimer *smsTimer;
    BOOL sendAutoMessage;
    UIAlertView *autoView;
    UIButton *envelopeButton;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *nightButton;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIImageView *centerView;
@property (weak, nonatomic) IBOutlet UIImageView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *smsSettingsButton;



- (IBAction)rightViewButtonClicked:(id)sender;

@end

@implementation HEALMainViewController

//############################################ Constants ############################################
static int const RIGHTVIEW_SETTINGS_BUTTON_TAG = 0;
static int const RIGHTVIEW_SMS_BUTTON_TAG = 1;
static int const RIGHTVIEW_NIGHT_BUTTON_TAG = 2;
static int const RIGHTVIEW_SMS_SETTINGS_BUTTON_TAG = 3;
static float const STANDARD_PAN_DURATION = 0.1;

//############################################ Setup Views, Buttons, Gestures and Timer ############################################
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
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
    [self circleButton];
    //[self sosButton];
    [self envelopeButton];
    //sosButton.hidden = YES;
    //sosButton.UserInteractionEnabled = NO;
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

//creates circle button that shows the states
- (void)circleButton
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"SoberArrow.png"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(stateSegue) forControlEvents:UIControlEventTouchUpInside];
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screen.size.width;
    CGFloat screenHeight = screen.size.height;
    button.frame = CGRectMake((0.05*screenWidth), (0.16*screenHeight), (0.9*screenWidth), (0.9*screenWidth));
    button.clipsToBounds = YES;
    
    button.layer.cornerRadius = (0.8*screenWidth)/2.0;
    
    
    [self.centerView addSubview:button];
}

- (void)updateCircleButton
{
    if (self.user.state == DEAD)
    {
        [button setImage:[UIImage imageNamed:@"DangerButton.png"] forState:UIControlStateNormal];
        
    } else if (self.user.state == SOBER)
    {
        [button setImage:[UIImage imageNamed:@"SoberArrow.png"] forState:UIControlStateNormal];
        
    } else if(self.user.state == TIPSY)
    {
        [button setImage:[UIImage imageNamed:@"TipsyArrow.png"] forState:UIControlStateNormal];
        
    } else if (self.user.state == DRUNK)
    {
        [button setImage:[UIImage imageNamed:@"DrunkArrow.png"] forState:UIControlStateNormal];
        
    } else if (self.user.state == DANGER)
    {
        //sosButton.hidden = NO;
        //sosButton.UserInteractionEnabled = YES;
        envelopeButton.hidden = NO;
        envelopeButton.UserInteractionEnabled = YES;
        
        [button setImage:[UIImage imageNamed:@"DangerButtonSMS.png"] forState:UIControlStateNormal];
    }

    
}

//updates labels according to BAC values
- (void)updateUI
{
    self.drinkStepper.value = self.user.currentNight.drinks;
    [self.drinkLabel setText:[NSString stringWithFormat:@"%d", self.user.currentNight.drinks]];
    [self setDateLabel:[NSDate dateWithTimeIntervalSince1970:self.user.currentNight.startTime]];
    
    [self updateRoundProgressBar];
    [self updateCircleButton];
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

//creates an envelope button
- (void)envelopeButton
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screen.size.width;
    CGFloat screenHeight = screen.size.height;
    envelopeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [envelopeButton addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    [envelopeButton setImage:[UIImage imageNamed:@"AboutUS.png"] forState:UIControlStateNormal];
    envelopeButton.frame = CGRectMake((0.353*screenWidth), (0.52*screenHeight), (0.3*screenWidth), (0.17*screenWidth));
    [self.centerView addSubview:envelopeButton];
}

//sets the date label-'youve been drinking since'
- (void)setDateLabel:(NSDate*)date
{
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"hh:mm a"];
    NSString *t = [dFormatter stringFromDate: date];
    
    //Getting rid of 6pm
    if(self.drinkStepper.value == 0)
    {
        [self.timeLabel setText:@"Ready to Start? Press Below!"];
    }
    
    else
    {
        [self.timeLabel setText:[NSString stringWithFormat:@"%@%@", @"You've been drinking since: ", t]];
    }
    
    
    
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
    [self updateUI];
}

- (IBAction)threeLinesButtonClicked:(id)sender
{
    [self toggleRightView];
}

- (void)panViews:(id)sender
{
    float centerRightEdgePos = self.centerView.frame.origin.x + self.centerView.frame.size.width;
    float parentRightEdgePos = self.view.frame.origin.x + self.view.frame.size.width;
    float toggleLeftFromPos = self.rightView.frame.origin.x + (0.75 * self.rightView.frame.size.width);
    float toggleRightFromPos = self.rightView.frame.origin.x + (0.25 * self.rightView.frame.size.width);
    
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        if (!slidRight && (centerRightEdgePos < toggleLeftFromPos)) {
            [self toggleRightView];
        } else if (slidRight && (centerRightEdgePos > toggleRightFromPos)) {
            [self toggleRightView];
        } else {
            [self resetViewPlacement];
        }
	}
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        if (-self.rightView.frame.size.width == self.centerView.frame.origin.x && translatedPoint.x > 0){
            self.centerView.center = CGPointMake(self.centerView.center.x + translatedPoint.x, self.centerView.center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        }
        else if (centerRightEdgePos == parentRightEdgePos && translatedPoint.x < 0){
            self.centerView.center = CGPointMake(self.centerView.center.x + translatedPoint.x, self.centerView.center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        }
    }
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if ((-self.rightView.frame.size.width < self.centerView.frame.origin.x) && (centerRightEdgePos < parentRightEdgePos)) {
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
        frame.origin.x = -self.rightView.frame.size.width;
        slidRight = YES;
    }
    
    [UIView animateWithDuration:STANDARD_PAN_DURATION animations:^{
        self.centerView.frame = frame;
    }];
    [button setUserInteractionEnabled:!slidRight];
    [self.addButton setUserInteractionEnabled:!slidRight];
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
    
    [UIView animateWithDuration:STANDARD_PAN_DURATION animations:^{
        self.centerView.frame = frame;
    }];
}

//SMS sending warning message
- (IBAction)sosDanger:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"SOS SMS" message:[NSString stringWithFormat:@"%@%@%@%@%@", @"Send message '", self.user.smsMessage, @"' to ", self.user.sosContact, @"?"] delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    [alertView show];
}

-(void)countDownDuration
{
    smsInt -= 1;
    if (smsInt == 1)
    {
        if (smsTimer != nil)
        {
            [smsTimer invalidate];
            smsTimer = nil;
        }
        [autoView dismissWithClickedButtonIndex:[autoView cancelButtonIndex] animated:TRUE];
        if(sendAutoMessage == TRUE)
        {
            [self sendSMS];
            self.user.currentNight.sosSent = TRUE;
        }
        
    }
}

- (IBAction)sosAuto:(id)sender
{
    sendAutoMessage = TRUE;
    smsInt = 6;
    smsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownDuration) userInfo:nil repeats:YES];
    autoView = [[UIAlertView alloc]initWithTitle:@"SOS SMS" message:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", @"Message '", self.user.smsMessage, @"' will be sent to ", self.user.sosContact, @" in ", [NSString stringWithFormat:@"%i", smsInt], @" seconds. Cancel?"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [autoView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        [self sendSMS];
        self.user.currentNight.sosSent = TRUE;
    }
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        sendAutoMessage = FALSE;
        smsTimer = nil;
        [smsTimer invalidate];
    }
}

//action when add drink is clicked
- (IBAction)runAddValueChanged:(id)sender
{
    self.drinkStepper.value += 1;
    [self valueChanged:_drinkStepper];
    [self updateRoundProgressBar];
    if(self.user.state >= self.user.smsState )
    {
        if (self.user.currentNight.sosSent == FALSE)
        {
            if(self.user.autoSMS == FALSE)
            {
                [self sosDanger:self];
            } else
            {
                [self sosAuto:self];
            }
        }
    }
}

- (void)updateRoundProgressBar
{
    self.roundProgressView.progress = self.user.wheelFill;
    self.roundProgressView.tintColor = self.user.wheelColorTint;
}

- (IBAction)valueChanged:(UIStepper *)sender
{
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
        [self updateUI];
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
    [self updateUI];
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
    } else if([segue.identifier isEqualToString:@"toSMSSettingsViewController"])
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
    [self.user.currentNight resetStartTime];//trying to get rid of 6pm


    [self updateUI];
    //sosButton.hidden = YES;
    //sosButton.UserInteractionEnabled = NO;
    envelopeButton.hidden = YES;
    envelopeButton.UserInteractionEnabled = NO;
    self.roundProgressView.progress = 0;
    [self.user.currentNight setDrunkStateMessages];
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
    
    self.user.currentNight.sosSent = TRUE;
    
    MFMessageComposeViewController *textComposer = [[MFMessageComposeViewController alloc] init];
    
    [textComposer setMessageComposeDelegate:self];
    
    if ([MFMessageComposeViewController canSendText]){ //if text messages can be sent
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:NULL] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTintColor:[UIColor blueColor]];

        NSArray *recipients = [NSArray arrayWithObjects:self.user.contactNumber, nil];
        [textComposer setRecipients:recipients];
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