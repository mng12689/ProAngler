//
//  AddAttributeViewController.m
//  ProAngler
//
//  Created by Michael Ng on 7/3/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "AddAttributeViewController.h"
#import "ProAnglerDataStore.h"
#import "AppDelegate.h"

@interface AddAttributeViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
- (IBAction)saveAttribute:(id)sender;
- (IBAction)cancelModal:(id)sender;

@end

@implementation AddAttributeViewController

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_wood.jpg"]];
    
    AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
    [appDelegate setTitle:[NSString stringWithFormat:@"Add %@",self.attributeType] forNavItem:self.navItem];
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setNavItem:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)saveAttribute:(id)sender
{
    if ([self.textField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid input" message:@"Please enter a valid input. If you wish to leave this page without saving, please hit 'Cancel'" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSManagedObject *newAttribute = [ProAnglerDataStore createNewAttribute:self.attributeType];;
        [newAttribute setValue:self.textField.text forKey:@"name"];
        [ProAnglerDataStore saveContext:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@Added",self.attributeType] object:self];
        [self dismissModalViewControllerAnimated:YES];
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
