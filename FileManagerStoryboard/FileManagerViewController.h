//
//  FileManagerViewController.h
//  FileManagerTest
//
//  Created by Stepan Paholyk on 11/5/16.
//  Copyright © 2016 Stepan Paholyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileManagerViewController : UITableViewController

- (id) initWithFolderPath:(NSString*)path;

- (IBAction) actionInfoCell:(id)sender;
@end
