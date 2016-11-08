//
//  SPTableViewCell.h
//  FileManagerStoryboard
//
//  Created by Stepan Paholyk on 11/7/16.
//  Copyright © 2016 Stepan Paholyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sizeLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;




@end
