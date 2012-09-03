//
//  AddAttributeViewController.m
//  ProAngler
//
//  Created by Michael Ng on 7/3/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "AddAttributeViewController.h"
#import "ProAnglerDataStore.h"

@interface AddAttributeViewController () <UITextFieldDelegate>

@end

@implementation AddAttributeViewController

@synthesize textField;
@synthesize delegate;
@synthesize context;
@synthesize attributeType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.delegate = self;
    self.navigationItem.title = self.attributeType;
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)saveAttribute:(id)sender
{
    if ([textField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid input"
                                                    message:@"Please enter a valid input. If you wish to leave this page without saving, please hit 'Cancel'"
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
    [alert show];
    }
    else{
        NSManagedObject *newAttribute = [ProAnglerDataStore createNewAttribute:attributeType];;
        [newAttribute setValue:textField.text forKey:@"name"];
        [ProAnglerDataStore saveContext];
        /*NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }*/
        
        [self.delegate attributeSaved:attributeType];
    }
}

- (IBAction)cancelModal:(id)sender {
   	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)txtField
{
    [txtField resignFirstResponder];
    return YES;
}

@end
