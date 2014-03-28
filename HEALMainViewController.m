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

}
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
- (IBAction)rightViewButtonClicked:(id)sender;

@end

@implementation HEALMainViewController


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
    [self.timeLabel setText:[NSString stringWithFormat:@"%@%@", @"Drinking since: ", t]];
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
    if (slidRight) {
        return;
    } else {
        [self toggleRightView];
    }
}

- (IBAction)swipedRight:(id)sender {
    if (slidRight) {
        [self toggleRightView];
    } else {
        return;
    }
}

- (void)toggleRightView
{
    if(slidRight)
    {
        CGRect frame = self.centerView.frame;
        frame.origin.x = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.centerView.frame = frame;
        }];
        
        slidRight = NO;
    }
    else if(!slidRight)
    {
        CGRect frame = self.centerView.frame;
        frame.origin.x = -self.rightView.frame.size.width;
        [UIView animateWithDuration:0.25 animations:^{
            self.centerView.frame = frame;
        }];
        
        slidRight = YES;
    }
}

- (IBAction)newNight:(UIButton *)sender
{
    [self resetTimer];
    [self.user.currentNight reset];
    [self updateLabels];
    [self.timeLabel setText:@"Ready to start? Press the plus below!"];
    [self updateBackground:@"Sober"];

}

- (void)countUp
{
    [self.bacLabel setText:[NSString stringWithFormat:@"%f", self.user.BAC]];
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue
{
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
    
    if (self.user.BAC < 0.02) {
        [self.stateButton setTitle:@"Sober" forState:UIControlStateNormal];
        
        [self updateBackground:@"Sober"];
        
        
        
    } else if(0.02 < self.user.BAC && self.user.BAC < 0.06)
    {
        [self.stateButton setTitle:@"Tipsy" forState:UIControlStateNormal];
        
        [self updateBackground:@"Sober"];

        
        
        
    } else if (0.06 < self.user.BAC && self.user.BAC < 0.2)
    {
        [self.stateButton setTitle:@"Drunk" forState:UIControlStateNormal];

        
        
    } else if (0.2 < self.user.BAC)
    {
        [self.stateButton setTitle:@"Danger" forState:UIControlStateNormal];

    }
    
    if (self.drinkStepper.value == 100)
    {
        [self.stateButton setTitle:@"Dead" forState:UIControlStateNormal];
        
    }
}

- (void)viewDidLoad
{

    [self updateBackground:@"Sober"];

    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    [self.view sendSubviewToBack:self.rightView];
    slidRight = NO;
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerViewTapped)];
    [self.centerView addGestureRecognizer:tapRecognizer];
    self.settingsButton.tag = 0;
    

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




-(IBAction)sendSMS:(id)sender{
    
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
    }
}
@end