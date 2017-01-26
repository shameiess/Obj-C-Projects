//
//  IVCell.m
//  InstagramViewer
//
//  Created by Kevin Nguyen on 1/9/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

#import "IVCell.h"
#import "UIImageView+AFNetworking.h"

@interface IVCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation IVCell

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        CGRect btnRect = CGRectMake(self.frame.size.width-30, self.frame.size.height-30 , 30, 30);
//        UIButton *favoriteButton = [[UIButton alloc] initWithFrame:btnRect];
//        [favoriteButton setTitle:@"✩" forState:UIControlStateNormal];
//        [self.contentView addSubview:favoriteButton];
//        
//        [favoriteButton addTarget:self action:@selector(deleteCellBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return self;
//}
//
//- (void)deleteCellBtnTapped:(UIButton *)sender
//{
//    NSLog(@"deleteCellBtnTapped");
//}


- (void)setImageUrl:(NSURL *)imageURL
{
    [self.imageView setImageWithURL:imageURL];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.imageView setImage:nil];
}

@end
