//
//  AddAttributeViewController.h
//  ProAngler
//
//  Created by Michael Ng on 7/3/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddAttributeViewController;

@protocol AddAttributeViewControllerDelegate <NSObject>
- (void)attributeSaved:(AddAttributeViewController*) addAttributeViewController;
@end

@interface AddAttributeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, weak) id <AddAttributeViewControllerDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext* context;
@property (nonatomic, strong) NSString* attributeType;

- (IBAction)saveAttribute:(id)sender;
- (IBAction)cancelModal:(id)sender;

@end
