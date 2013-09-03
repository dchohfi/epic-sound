//
//  UITableViewCell+Additions.h
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Additions)
+ (void) registerCellOnTableView: (UITableView *) tableView;
+ (instancetype) dequeueCellInTableView: (UITableView *) tableView;
@end
