//
//  PageOneMapViewController.h
//  ProAngler
//
//  Created by Michael Ng on 9/9/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AnalysisPagedViewController;

@interface PageOneMapViewController : UIViewController

@property (strong) AnalysisPagedViewController *analysisViewController;
-(void)presentFilterModal;

@end
