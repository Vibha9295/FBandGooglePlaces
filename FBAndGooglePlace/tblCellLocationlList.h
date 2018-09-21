//
//  tblCellLocationlListTableViewCell.h
//  FBAndGooglePlace
//
//  Created by bhavik on 9/9/16.
//  Copyright © 2016 bhavik@zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tblCellLocationlList: UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblLocationName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLocationImg;

@end
