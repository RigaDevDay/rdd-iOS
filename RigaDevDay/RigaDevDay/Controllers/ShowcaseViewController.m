//
//  ViewController.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "ShowcaseViewController.h"
#import "SWRevealViewController.h"
#import "ShowCaseCell.h"

@interface ShowcaseViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ShowcaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 13;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
#warning TODO
    if (indexPath.item == 0 || indexPath.item == 5) {
        return CGSizeMake(312, 160);
    }
    
    return CGSizeMake(154, 154);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShowCaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShowCaseCell" forIndexPath:indexPath];
//    NSString *backroundImageName = [NSString stringWithFormat:@"backstage_%i.jpeg",arc4random() % 12];
//    cell.imageViewBackground.image = [UIImage imageNamed:backroundImageName];
    return cell;
}

@end
