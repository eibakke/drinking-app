//
//  HEALEditSettingsViewController.m
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALEditSettingsViewController.h"

@interface HEALEditSettingsViewController ()
{
    sexes newSex;
    
    BOOL firstUse;
}

@end

@implementation HEALEditSettingsViewController

//############################################ Setup Interactive and Initialize SubViews and User Interaction When View Loads ############################################
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (!self.user) {
        firstUse = YES;
        self.user = [[HEALUser alloc]init];
    }
}

// Setup all UI elements in the ViewController called from viewDidLoad only
- (void)setupUI
{
    // Set background image
    [self.imageViewBackground setImage:[UIImage imageNamed:@"EmptySettings.png"]];
    
    // Initialize all the fields to have values from the user object
    [self initFields];
    
    // Setup gestures and textfield delegate
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground:)];
    [self.view addGestureRecognizer:tapBackground];
    
    [[self weightTextField] setDelegate:self];
    [[self nameTextField] setDelegate:self];
    
    // We need a custom back button to be able to get the new night warning, but this removes the little arrow next to the button!!! Very annoying I know...
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Done"
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backButtonClicked)];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

// Initializes text fields and radiobuttons to reflect user object info
- (void)initFields
{
    if (self.user.weight != 0) {
        self.weightTextField.text = [NSString stringWithFormat:@"%d", self.user.weight];
        self.nameTextField.text = self.user.name;
    }
    // Set the text in the textfields to come from the user defaults, if they have been set yet
    if(self.user.sex == FEMALE)
    {
        [self.femaleRadioButton setSelected:YES];
    } else if(self.user.sex == MALE)
    {
        [self.maleRadioButton setSelected:YES];
    }
}


//############################################ Selectors to User Interaction ############################################

// Called when the user clicks the non-arrowed back button
- (void)backButtonClicked
{
    if ([self userInfoUpdated] && (self.user.currentNight.drinks != 0)) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Changing your data will start a new night."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    } else if (firstUse && [self userInfoUpdated]) {
        [self performSegueWithIdentifier:@"settingsMainSegue" sender:self];
    } else if ([self.weightTextField.text integerValue] == 0) {
        [self.weightWarningLabel setHidden:NO];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// Called when the user interacts with pop up alert views
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { // Button index 1 is the OK button in the New Night warning
        [self updateUser];
        [self.user.currentNight reset];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// When the user taps the background we want to collapse the keyboard
- (void)tapBackground:(UIGestureRecognizer *)gestureRecognizer;
{
    [[self nameTextField] resignFirstResponder];
    [[self weightTextField] resignFirstResponder];
}

// To get the keyboard to collapse when return is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}





//// Move the whole view up a little when editing a textfield
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self animateTextField: textField up: YES];
//}

//// Move it back down when done editing
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self animateTextField: textField up: NO];
//}





//############################################ Everything that happens when we leave the View Controller (Updating User, Checking for New Input etc.) ############################################

// When navigating away from the view controller, we want to save
- (void)viewDidDisappear:(BOOL)animated
{
    if ([self userInfoUpdated]) {
        [self updateUser];
    }
}

// Updates the user in NSUserDefaults and in the User object
- (void)updateUser
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *weight = [NSNumber numberWithDouble:[[self.weightTextField text] doubleValue]];
    [defaults setObject:weight forKey:@"userWeight"];
    [defaults setObject:[self.nameTextField text] forKey:@"userName"];
    
    if ([self.maleRadioButton isSelected])
    {
        [defaults setObject:@"M" forKey:@"userSex"];
    }
    else if([self.femaleRadioButton isSelected])
    {
        [defaults setObject:@"F" forKey:@"userSex"];
    }
    
    self.user.weight = [[self.weightTextField text] intValue];
    self.user.name = [self.nameTextField text];
    
    self.user.sex = newSex;
    
    @try {
        [defaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"Data save failed.");
    }
}


// Checks if the info the user has entered is different from what is stored
- (BOOL)userInfoUpdated
{
    [self setNewSex];
    
    int currWeight = self.user.weight;
    sexes currSex = self.user.sex;
    
    if ((currWeight == [[self.weightTextField text] intValue]) && (currSex == newSex)) {
        return NO;
    } else {
        return YES;
    }
}

// Helper method to get the sex from the radiobuttons called from userInfoUpdated
- (void)setNewSex
{
    if ([self.maleRadioButton isSelected]) {
        newSex = MALE;
    } else if([self.femaleRadioButton isSelected]) {
        newSex = FEMALE;
    }
}


//############################################ Animations ############################################

// The animation with bool for moving up or down. Source: user Amagrammer at stackoverflow. Post URL: http://stackoverflow.com/questions/1247113/iphone-keyboard-covers-uitextfield
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 50;
    const float movementDuration = 0.1f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"settingsMainSegue"]) {
        HEALMainViewController *mainController = [segue destinationViewController];
        mainController.user = self.user;
    }
}

// Adds a return button to the keypad
//- (void)addButtonToKeyboard {
//	// create custom button
//	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	doneButton.frame = CGRectMake(0, 163, 106, 53);
//	doneButton.adjustsImageWhenHighlighted = NO;
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) {
//		[doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
//		[doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
//	} else {
//		[doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
//		[doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
//	}
//	[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
//	// locate keyboard view
//	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
//	UIView* keyboard;
//	for(int i=0; i<[tempWindow.subviews count]; i++) {
//		keyboard = [tempWindow.subviews objectAtIndex:i];
//		// keyboard found, add the button
//		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
//			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
//				[keyboard addSubview:doneButton];
//		} else {
//			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
//				[keyboard addSubview:doneButton];
//		}
//	}
//}
@end