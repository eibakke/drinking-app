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

}
@property (weak, nonatomic) IBOutlet UIButton *nightButton;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

- (IBAction)rightViewButtonClicked:(id)sender;

@end

@implementation HEALMainViewController

//segue to drunkstate view controller
- (void)stateSegue
{
    [self performSegueWithIdentifier:@"toStateViewController" sender:self];
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
    button.frame = CGRectMake((0.1*screenWidth), (0.13*screenHeight), (0.8*screenWidth), (0.8*screenWidth));
    button.clipsToBounds = YES;
    
    button.layer.cornerRadius = (0.8*screenWidth)/2.0;

    
    [self.centerView addSubview:button];
}

//creates SOS button
- (void)sosButton
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screen.size.width;
    CGFloat screenHeight = screen.size.height;
    sosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sosButton addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    sosButton.frame = CGRectMake((0.35*screenWidth), (0.55*screenHeight), (0.3*screenWidth), (0.15*screenHeight));
    //[button setBackgroundColor:[UIColor redColor]];
    [self.centerView addSubview:sosButton];
}

- (IBAction)sosDanger:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"SOS SMS" message:@"Should probably getText from stored message, maybe something with recipient, too." delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self sendSMS];        
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

//sets the date label-'youve been drinking since'
- (void)setDateLabel:(NSDate*)date
{
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"hh:mm a"];
    NSString *t = [dFormatter stringFromDate: date];
    [self.timeLabel setText:[NSString stringWithFormat:@"%@%@", @"You've been drinking since: ", t]];
}

//action when add drink is clicked
- (IBAction)runAddValueChanged:(id)sender
{
    self.drinkStepper.value += 1;
    [self valueChanged:_drinkStepper];
    [UIView animateWithDuration:3.0 animations:^{
        self.roundProgressView.progress = 0.5;
    }];
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
        [self updateLabels];
    }
}

- (IBAction)threeLinesButtonClicked:(id)sender {
    [self toggleRightView];
}

- (IBAction)swipedLeft:(id)sender {
    if (!slidRight) {
        [self toggleRightView];
    }
}

- (IBAction)swipedRight:(id)sender {
    if (slidRight) {
        [self toggleRightView];
    }
}

-(void)movePanel:(id)sender {
	[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
	CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        NSLog(@"Started panning!");
//        UIView *childView = nil;
//        
//        if(velocity.x > 0) {
//            if (!_showingRightPanel) {
//                childView = [self getLeftView];
//            }
//        } else {
//            if (!_showingLeftPanel) {
//                childView = [self getRightView];
//            }
//			
//        }
//        // make sure the view we're working with is front and center
//        [self.view sendSubviewToBack:childView];
//        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        NSLog(@"Panning ended!");
//        if(velocity.x > 0) {
//            // NSLog(@"gesture went right");
//        } else {
//            // NSLog(@"gesture went left");
//        }
//        
//        if (!_showPanel) {
//            [self movePanelToOriginalPosition];
//        } else {
//            if (_showingLeftPanel) {
//                [self movePanelRight];
//            }  else if (_showingRightPanel) {
//                [self movePanelLeft];
//            }
//        }
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        NSLog(@"Panning changed, and x velocity is %f", velocity.x);
//        if(velocity.x > 0) {
//            // NSLog(@"gesture went right");
//        } else {
//            // NSLog(@"gesture went left");
//        }
//        
//        // are we more than halfway, if so, show the panel when done dragging by setting this value to YES (1)
//        _showPanel = abs([sender view].center.x - _centerViewController.view.frame.size.width/2) > _centerViewController.view.frame.size.width/2;
//        
//        // allow dragging only in x coordinates by only updating the x coordinate with translation position
//        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
//        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
//        
//        // if you needed to check for a change in direction, you could use this code to do so
//        if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0) {
//            // NSLog(@"same direction");
//        } else {
//            // NSLog(@"opposite direction");
//        }
//        
//        _preVelocity = velocity;
	}
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
    
    [UIView animateWithDuration:0.25 animations:^{
        self.centerView.frame = frame;
    }];
}

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
}

- (void)countUp
{
    [self.bacLabel setText:[NSString stringWithFormat:@"%f", self.user.BAC]];
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue
{
    slidRight = NO;
    [self updateLabels];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

//updates background programmatically according to drinking state
- (void) updateBackground:(NSString*) State
{
 
    if ([State  isEqual: @"Sober"]){
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:(@"empty.png")] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        self.centerView.backgroundColor = [UIColor colorWithPatternImage:image];
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:(@"Flip.png")] drawInRect:self.view.bounds];
        UIImage *imageBack = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.rightView.backgroundColor = [UIColor colorWithPatternImage:imageBack];
        
    }

    
    if ([State  isEqual: @"Tipsy"]){
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:(@"empty.png")] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.centerView.backgroundColor = [UIColor colorWithPatternImage:image];
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:(@"Flip.png")] drawInRect:self.view.bounds];
        UIImage *imageBack = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.rightView.backgroundColor = [UIColor colorWithPatternImage:imageBack];
    }
    
    
    if ([State  isEqual: @"Drunk"]){
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:(@"empty.png")] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        

        
        self.centerView.backgroundColor = [UIColor colorWithPatternImage:image];
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:(@"Flip.png")] drawInRect:self.view.bounds];
        UIImage *imageBack = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.rightView.backgroundColor = [UIColor colorWithPatternImage:imageBack];

    }
    
    if ([State  isEqual: @"Danger"]){
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:(@"empty.png")] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.centerView.backgroundColor = [UIColor colorWithPatternImage:image];
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:(@"Flip.png")] drawInRect:self.view.bounds];
        UIImage *imageBack = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.rightView.backgroundColor = [UIColor colorWithPatternImage:imageBack];
    }
    
    if ([State  isEqual: @"Dead"]){
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:(@"empty.png")] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.centerView.backgroundColor = [UIColor colorWithPatternImage:image];
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:(@"Flip.png")] drawInRect:self.view.bounds];
        UIImage *imageBack = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.rightView.backgroundColor = [UIColor colorWithPatternImage:imageBack];
    }
    
}

//updates labels according to BAC values
- (void) updateLabels
{
    self.drinkStepper.value = self.user.currentNight.drinks;
    [self.drinkLabel setText:[NSString stringWithFormat:@"%d", self.user.currentNight.drinks]];
    [self setDateLabel:[NSDate dateWithTimeIntervalSince1970:self.user.currentNight.startTime]];
    [self countUp];
    
    if (self.drinkStepper.value == 100)
    {
        //[button setTitle:@"Dead" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"DangerButton.png"] forState:UIControlStateNormal];
        
        
        //[self updateBackground:@"Dead"];
    } else if (self.user.BAC < 0.02)
    {
        //[button setTitle:@"Sober" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"CenterButtonSober.png"] forState:UIControlStateNormal];
        
        //[self updateBackground:@"Sober"];
        
    } else if(0.02 < self.user.BAC && self.user.BAC < 0.06)
    {
        //[button setTitle:@"Tipsy" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"TipsyButton.png"] forState:UIControlStateNormal];

        
        //[self updateBackground:@"Tipsy"];
   
    } else if (0.06 < self.user.BAC && self.user.BAC < 0.2)
    {
        //[button setTitle:@"Drunk" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"DrunkButton.png"] forState:UIControlStateNormal];

        
        //[self updateBackground:@"Drunk"];
        
    } else if (0.2 < self.user.BAC && self.user.BAC < 1)
    {
        //[self sosButton];
        //sosButton.hidden = NO;
        //sosButton.UserInteractionEnabled = YES;
        
        //[button setTitle:@"Danger" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"DangerButtonSMS.png"] forState:UIControlStateNormal];
        
        [self sosDanger:self];
        
        //[self updateBackground:@"Danger"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestures];
    [self circleButton];
    [self updateBackground:@"Sober"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    [self.view sendSubviewToBack:self.rightView];
    slidRight = NO;
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerViewTapped)];
    [self.centerView addGestureRecognizer:tapRecognizer];
    self.settingsButton.tag = 0;
    self.smsButton.tag = 1;
    self.nightButton.tag = 2;
}

-(void)setupGestures {
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
    
	[self.view addGestureRecognizer:panRecognizer];
}

-(void)centerViewTapped
{
    if(!slidRight) return;
    else {
        [self toggleRightView];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//handles segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toStateViewController"])
    {
        HEALDrunkStateViewController *controller = [segue destinationViewController];
        controller.user = self.user;
    }
    if([segue.identifier isEqualToString:@"toSettingsViewController"])
    {
        HEALEditSettingsViewController *controller = [segue destinationViewController];
        controller.user = self.user;
    }
    
}

//send SMS
-(void)sendSMS{
    
    MFMessageComposeViewController *textComposer = [[MFMessageComposeViewController alloc] init];
    
    [textComposer setMessageComposeDelegate:self];
    
    if ([MFMessageComposeViewController canSendText]){ //if text messages can be sent
        [textComposer setRecipients:[NSArray arrayWithObjects: nil]]; //allows user to choose number to send text to (replace nil by number to send it to a predetermined number)
        [textComposer setBody:@"I am drunk! HELP ME!!!"];
        [self presentViewController:textComposer animated:YES completion:NULL];
        
    } else { //simulator will not allow text messages to be sent
        NSLog(@"Cannot Open Text.");
    }
    
}

//for dismissing text messaging in app if we cancel or send it
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
}
@end