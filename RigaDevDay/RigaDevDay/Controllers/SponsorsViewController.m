//
//  OrganizersViewController.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/24/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "SponsorsViewController.h"
#import "SWRevealViewController.h"
#import "WebserviceManager.h"
#import "Sponsor.h"
#import "SponsorCollectionViewCell.h"
#import "DataManager.h"


@interface SponsorsViewController ()

@property (nonatomic, strong) NSArray *pSponsors;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (weak, nonatomic) IBOutlet UICollectionView *iboCollectionView;

@end

@implementation SponsorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.pSponsors = [[DataManager sharedInstance] allSponsors];
    [self.iboCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.pSponsors count];
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SponsorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SponsorCell" forIndexPath:indexPath];
    Sponsor *sponsor = self.pSponsors[indexPath.row];
    
    [[WebserviceManager sharedInstance] loadImage:sponsor.img withCompletionBlock:^(id data) {
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.iboImageView.image = image;
            });
        }
    } andErrorBlock:^(NSError *error) {
        
    }];
    //    NSString *backroundImageName = [NSString stringWithFormat:@"backstage_%i.jpeg",arc4random() % 12];
    //    cell.imageViewBackground.image = [UIImage imageNamed:backroundImageName];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Sponsor *sponsor = self.pSponsors[indexPath.row];
    if (sponsor.url.length) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sponsor.url]];
    }
}

@end