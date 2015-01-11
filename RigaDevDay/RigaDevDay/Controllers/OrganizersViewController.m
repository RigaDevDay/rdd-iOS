//
//  OrganizersViewController.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/24/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "OrganizersViewController.h"
#import "SWRevealViewController.h"
#import "OrganizersTableViewCell.h"

@interface OrganizersViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *section1;
    NSMutableArray *section2;
    NSMutableArray *section3;
    NSMutableArray *section4;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrganizersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self setupArrays];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [section1 count];
            break;
        case 1:
            return [section2 count];
            break;
        case 2:
            return [section3 count];
            break;
        case 3:
            return [section4 count];
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrganizersTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrganizersCell"];
    switch (indexPath.section) {
        case 0:
            cell.logoImageView.image = section1[indexPath.row];
            break;
        case 1:
            cell.logoImageView.image = section2[indexPath.row];
            break;
        case 2:
            cell.logoImageView.image = section3[indexPath.row];
            break;
        case 3:
            cell.logoImageView.image = section4[indexPath.row];
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Organizers of the Event";
            break;
        case 1:
            return @"Our dear Sponsors";
            break;
        case 2:
            return @"Supported by";
            break;
        case 3:
            return @"With help from the Community";
            break;
        default:
            break;
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:16];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
     header.contentView.backgroundColor = [UIColor blackColor];
}
#define ImageMaxHeight 50

-(void)setupArrays {
    section1 = [NSMutableArray new];
    [section1 addObject:[UIImage imageNamed:@"gdg-riga.png"]];
    [section1 addObject:[UIImage imageNamed:@"jug.png"]];
    [section1 addObject:[UIImage imageNamed:@"lvoug.png"]];
    
    for (int i = 0; i < [section1 count]; i++) {
        UIImage *image = section1[i];
        image = [self image:image scaledToFitSize:CGSizeMake(image.size.width, ImageMaxHeight)];
        section1[i] = image;
    }
    
    section2 = [NSMutableArray new];
    [section2 addObject:[UIImage imageNamed:@"ok_logo.png"]];
    [section2 addObject:[UIImage imageNamed:@"google.png"]];
    [section2 addObject:[UIImage imageNamed:@"ctco_logo.png"]];
    [section2 addObject:[UIImage imageNamed:@"4finance_logo.png"]];
    [section2 addObject:[UIImage imageNamed:@"idea-port-riga.png"]];
    [section2 addObject:[UIImage imageNamed:@"rubylight.png"]];
    [section2 addObject:[UIImage imageNamed:@"accenture.png"]];
    [section2 addObject:[UIImage imageNamed:@"innowate.png"]];
    [section2 addObject:[UIImage imageNamed:@"gi.png"]];
    [section2 addObject:[UIImage imageNamed:@"openshift.png"]];
    [section2 addObject:[UIImage imageNamed:@"neueda.png"]];
    
    for (int i = 0; i < [section2 count]; i++) {
        UIImage *image = section2[i];
        image = [self image:image scaledToFitSize:CGSizeMake(image.size.width, ImageMaxHeight)];
        section2[i] = image;
    }
    
    section3 = [NSMutableArray new];
    [section3 addObject:[UIImage imageNamed:@"oreilly.jpg"]];
    [section3 addObject:[UIImage imageNamed:@"oraclepress.png"]];
    [section3 addObject:[UIImage imageNamed:@"github.png"]];
    [section3 addObject:[UIImage imageNamed:@"techhub.png"]];
    [section3 addObject:[UIImage imageNamed:@"riga-comm.png"]];
    [section3 addObject:[UIImage imageNamed:@"startuphunt.png"]];
    [section3 addObject:[UIImage imageNamed:@"enjoy.png"]];
    [section3 addObject:[UIImage imageNamed:@"kursors.png"]];
    [section3 addObject:[UIImage imageNamed:@"pluralsight.png"]];
    [section3 addObject:[UIImage imageNamed:@"BdaLogo.png"]];
    [section3 addObject:[UIImage imageNamed:@"MCE_black_normal_large.png"]];
    
    for (int i = 0; i < [section3 count]; i++) {
        UIImage *image = section3[i];
        image = [self image:image scaledToFitSize:CGSizeMake(image.size.width, ImageMaxHeight)];
        section3[i] = image;
    }
    
    section4 = [NSMutableArray new];
    [section4 addObject:[UIImage imageNamed:@"jug-kpi.png"]];
    [section4 addObject:[UIImage imageNamed:@"jug_kaunas.png"]];
    [section4 addObject:[UIImage imageNamed:@"jug_vilnius.png"]];
    [section4 addObject:[UIImage imageNamed:@"gtug_sthlm.png"]];
    [section4 addObject:[UIImage imageNamed:@"ldn.png"]];
    [section4 addObject:[UIImage imageNamed:@"startup-latvia.png"]];
    [section4 addObject:[UIImage imageNamed:@"devclub.png"]];
    [section4 addObject:[UIImage imageNamed:@"javaguru.png"]];
    [section4 addObject:[UIImage imageNamed:@"progmeistars.png"]];
    [section4 addObject:[UIImage imageNamed:@"ouge.png"]];
    
    for (int i = 0; i < [section4 count]; i++) {
        UIImage *image = section4[i];
        image = [self image:image scaledToFitSize:CGSizeMake(image.size.width, ImageMaxHeight)];
        section4[i] = image;
    }
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(OrganizersTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.logoImageView.frame = [self bestRectForImageViewInCell:cell];
}

- (CGRect)bestRectForImageViewInCell:(OrganizersTableViewCell *)cell {
    CGRect returnRect = cell.logoImageView.frame;
    returnRect.size = cell.logoImageView.image.size;
    returnRect.origin.x = cell.contentView.frame.size.width/2 - returnRect.size.width/2;
    return returnRect;
}

- (UIImage *)image:(UIImage *)image scaledToFitSize:(CGSize)size
{
    //calculate rect
    CGFloat aspect = image.size.width / image.size.height;
    if (size.width / aspect <= size.height)
    {
        return [self image:image scaledToSize:CGSizeMake(size.width, size.width / aspect)];
    }
    else
    {
        return [self image:image scaledToSize:CGSizeMake(size.height * aspect, size.height)];
    }
}

- (UIImage *)image:(UIImage *)image scaledToSize:(CGSize)size
{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [image drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return imageOut;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *webURL = @"";

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                webURL = @"http://gdgriga.lv/";
                break;
            case 1:
                webURL = @"http://jug.lv/";
                break;
            case 2:
                webURL = @"http://lvoug.lv/";
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                webURL = @"http://ok.ru/";
                break;
            case 1:
                webURL = @"https://developers.google.com/";
                break;
            case 2:
                webURL = @"http://www.ctco.lv/";
                break;
            case 3:
                webURL = @"http://www.4finance.com/";
                break;
            case 4:
                webURL = @"http://www.ideaportriga.com/";
                break;
            case 5:
                webURL = @"http://www.rubylight.com/";
                break;
            case 6:
                webURL = @"http://www.accenture.com/us-en/pages/index.aspx";
                break;
            case 7:
                webURL = @"http://www.innowate.com/";
                break;
            case 8:
                webURL = @"http://www.game-insight.com/en";
                break;
            case 9:
                webURL = @"https://www.openshift.com/";
                break;
            case 10:
                webURL = @"http://neueda.lv/";
                break;
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                webURL = @"http://www.oreilly.com/";
                break;
            case 1:
                webURL = @"http://community.oraclepressbooks.com/";
                break;
            case 2:
                webURL = @"https://github.com/";
                break;
            case 3:
                webURL = @"http://riga.techhub.com/";
                break;
            case 4:
                webURL = @"http://rigacomm.com/";
                break;
            case 5:
                webURL = @"http://startuphunt.lv/";
                break;
            case 6:
                webURL = @"http://www.enjoyrecruitment.lv/lv/personala-atlase";
                break;
            case 7:
                webURL = @"http://www.kursors.lv/";
                break;
            case 8:
                webURL = @"http://www.pluralsight.com/";
                break;
            case 9:
                webURL = @"http://www.bda.lv/bda4/";
                break;
            case 10:
                webURL = @"http://mceconf.com/";
                break;
            default:
                break;
        }
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                webURL = @"http://jug.ua/";
                break;
            case 1:
                webURL = @"http://kaunas-jug.lt/";
                break;
            case 2:
                webURL = @"http://vilnius-jug.lt/";
                break;
            case 3:
                webURL = @"https://sites.google.com/site/stockholmgtug/";
                break;
            case 4:
                webURL = @"http://www.meetup.com/Latvian-Developers-Network/";
                break;
            case 5:
                webURL = @"http://startuplatvia.eu/";
                break;
            case 6:
                webURL = @"http://www.devclub.eu/";
                break;
            case 7:
                webURL = @"http://www.javaguru.lv/";
                break;
            case 8:
                webURL = @"http://www.progmeistars.lv/";
                break;
            case 9:
                webURL = @"https://www.ouge.eu/wp/";
                break;
            default:
                break;
        }
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
}

@end
