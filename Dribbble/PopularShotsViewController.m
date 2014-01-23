//
//  ViewController.m
//  Dribbble
//
//  Created by John Andrews on 1/23/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "PopularShotsViewController.h"

@interface PopularShotsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *shots;


@end

@implementation PopularShotsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.shots = [NSMutableArray array];

    // http://api.dribbble.com/shots/everyone
    
    // 1) crate a URL
    NSURL *url = [NSURL URLWithString:@"http://api.dribbble.com/shots/everyone"];
    
    //2) create a NSURLRequest. This embodies the request sent to the server.
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:0
                                         timeoutInterval:8.0];
    [request HTTPMethod];

    // 3) fire the request: The new and BETTER way
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               //update UI
                               
                               NSDictionary *jSONdictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                              options:0
                                                                                                error:nil];
                               
                               self.shots = [jSONdictionary objectForKey:@"shots"];
                               [self.tableView reloadData];
                               
//                               for (NSDictionary *shot in self.shots) {
//                                   [[shot objectForKey:@"player"] objectForKey:@"followers_count"];
//                                   NSLog(@"%@", [[shot objectForKey:@"player"] objectForKey:@"followers_count"] );
//                               }
//                               
//                               //--- above and below are same thing ---
//                               /*
//                               NSArray *shots = jSONdictionary[@"shots"];
//                               for (NSDictionary *shotURL in shots) {
//                                   //NSLog(@"%@", shotURL[@"image_url"]);
//                               }*/

                               //operation:dispatch to background if needed...
                               
                           }];


}

#pragma mark - TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shots.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *shot = self.shots[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Shot"];
    
    /* SLOW WAY
    NSURL *imageURL = [NSURL URLWithString:shot[@"image_url"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL]; //this call is synchronous
    cell.imageView.image = [UIImage imageWithData:imageData];
    */
    
    NSURL *imageUrl = [NSURL URLWithString:shot[@"image_url"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl
                                             cachePolicy:0
                                         timeoutInterval:8.0];
    [request HTTPMethod];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               
                               //dispatch methods are used for low level threading and talks to GCD
                               //important part of this method that makes images/data to rum smoothly
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   cell.imageView.image = [UIImage imageWithData:data];
                               });
                           }];
    
    return cell;
    
}





@end
