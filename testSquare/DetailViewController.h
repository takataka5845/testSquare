//
//  DetailViewController.h
//  testSquare
//
//  Created by takashi kato on 2014/03/26.
//  Copyright (c) 2014年 StudioDec2July. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
