//
//  ViewController.m
//  JsonExample
//
//  Created by eda on 14/11/22.
//
//

#import "ViewController.h"
#import "CustomCell.h"
#import "DetailViewController.h"

#define loansURL [NSURL URLWithString: @"http://www.washingtonpost.com/wp-srv/simulation/simulation_test.json"]

#define mainQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ViewController ()
@property (strong,nonatomic) NSMutableArray *arrayOftitles;
@property (strong,nonatomic) NSMutableArray *arrayOfDates;
@property (strong,nonatomic) NSMutableArray *arrayOfContents;
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(mainQueue, ^{
        
        NSData *data = [NSData dataWithContentsOfURL:loansURL];
        
        //when data gets back - then do smth. until then dont do anything
        [self performSelectorOnMainThread:@selector(dataRetreived:) withObject:data waitUntilDone:YES];
        
    });
}
-(void)dataRetreived:(NSData*) dataResponse
{
    NSError *error;
    
    //Get all the data
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:&error];
    
    //Get the first part of the data
    NSArray *postsArray = [jsonDict objectForKey:@"posts"];
    
    //Extract the data
    self.arrayOftitles = [[NSMutableArray alloc] init];
    self.arrayOfDates = [[NSMutableArray alloc] init];
    self.arrayOfContents = [[NSMutableArray alloc] init];
    for (int i=0; i<postsArray.count; i++) {
        NSDictionary *postsDict = [postsArray objectAtIndex:i];
        NSString *title = [postsDict objectForKey:@"title"];
        NSString *date = [postsDict objectForKey:@"date"];
        NSString *contents = [postsDict objectForKey:@"content"];
        [self.arrayOftitles addObject:title];
        [self.arrayOfDates addObject:date];
        [self.arrayOfContents addObject:contents];
        //NSLog(@"the title is: %@",title);
    }
   
    [self.myTable reloadData];
    
    //Show the data
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOftitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCell *customCell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    customCell.lblCellTitle.text = self.arrayOftitles[indexPath.row];
    customCell.lblCellDate.text = self.arrayOfDates[indexPath.row];
    
    return customCell;

}
/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"SegueIdentifier"]) {
        NSIndexPath *indexPath = [self.myTable indexPathForSelectedRow];
        DetailViewController *desViewController = segue.destinationViewController;
        
        desViewController.nameContent = self.arrayOfContents[indexPath.row];
    }
}
 */
- (IBAction)sortByDateBtn:(id)sender {
    //we use descriptors to order an array ascending
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *datesordered = [self.arrayOfDates sortedArrayUsingDescriptors:sortDescriptors];
    NSArray *titlesordered = [self.arrayOftitles sortedArrayUsingDescriptors:sortDescriptors];
    self.arrayOfDates = [datesordered mutableCopy];//assign the array to a mutableArray
    self.arrayOftitles = [titlesordered mutableCopy];
    [self.myTable reloadData];//reload data in table
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DetailViewController *destinationViewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    destinationViewController.nameContent = self.arrayOfContents[indexPath.row];
    [self.navigationController pushViewController:destinationViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
