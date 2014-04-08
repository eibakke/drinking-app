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

- (IBAction)rightViewButtonClicked:(id)sender;

@end

@implementation HEALMainViewController

- (void)stateSegue
{
    [self performSegueWithIdentifier:@"toStateViewController" sender:self];
}

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


- (void)resetTimer
{
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countUp) userInfo:nil repeats:YES];
}


- (void)setDateLabel:(NSDate*)date
{
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"hh:mm a"];
    NSString *t = [dFormatter stringFromDate: date];
    [self.timeLabel setText:[NSString stringWithFormat:@"%@%@", @"You've been drinking since: ", t]];
}

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
        } else if ((centerViewCenter.x - self.centerView.center.x <= self.rightView.frame.size.width) && (self.centerView.center.x <= centerViewCenter.x)) {
            self.centerView.center = CGPointMake(self.centerView.center.x + translatedPoint.x, self.centerView.center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        }
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
    centerViewCenter.x = self.centerView.frame.size.width / 2;
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
    if(slidRight) [self toggleRightView];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertUser:(NSString*) alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

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