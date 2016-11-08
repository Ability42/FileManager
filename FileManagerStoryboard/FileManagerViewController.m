//
//  FileManagerViewController.m
//  FileManagerTest
//
//  Created by Stepan Paholyk on 11/5/16.
//  Copyright © 2016 Stepan Paholyk. All rights reserved.
//

#import "FileManagerViewController.h"
#import "SPTableViewCell.h"

@interface FileManagerViewController ()

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSArray *contents;
@property (strong, nonatomic) NSString *selectedPath;

@end

@implementation FileManagerViewController

#pragma mark - Init

- (id) initWithFolderPath:(NSString *)path
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.path = path;
    }
    return self;
}

- (void) setPath:(NSString *)path
{
    _path = path;
    NSError *error = nil;
    self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path
                                                                        error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }

    [self.tableView reloadData]; // check without this method
    
    self.navigationItem.title = [self.path lastPathComponent];
    
}

#pragma mark - Custom

- (BOOL) isDirectoryAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (!self.path) {
        self.path = @"/Users/stepanpaholyk/Documents";
    }
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.navigationController.viewControllers count] > 1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back to root"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionBackToRoot:)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"PATH: %@", self.path);
    NSLog(@"Number of vc's on stack: %lu", [self.navigationController.viewControllers count]);
    NSLog(@"Current index of vc on stack: %lu", [self.navigationController.viewControllers indexOfObject:self]);
    NSLog(@"\n");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Actions

- (void)actionBackToRoot:(UIBarButtonItem*)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionInfoCell:(id)sender
{
    NSLog(@"actionInfoCell"); 
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *fileID = @"fileCell";
    static NSString *folderID = @"folderCell";
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:folderID];
        cell.textLabel.text = fileName;
        
        return cell;
    } else {
        NSString *path = [self.path stringByAppendingPathComponent:fileName];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        SPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fileID];
        
        cell.nameLabel.text = fileName;
        cell.sizeLable.text = [NSString stringWithFormat:@"%lld", [attributes fileSize]];
        cell.dateLabel.text =[NSString stringWithFormat:@"%@", [attributes fileModificationDate]];
        return cell;
    }
  
    
}


#pragma mark - UITableViewDelegate'

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isDirectoryAtIndexPath:indexPath]) {
        return 72.f;
    } else {
        return 96.f;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
        
//        FileManagerViewController *fvc = [[FileManagerViewController alloc] initWithFolderPath:filePath];
//        [self.navigationController pushViewController:fvc animated:YES];
        
//        FileManagerViewController *fmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FileManager"];
//        fmvc.path = filePath;
//        [self.navigationController pushViewController:fmvc animated:YES];
        
        self.selectedPath = filePath;
        
        [self performSegueWithIdentifier:@"navigateDeep" sender:nil];
    }
}

#pragma mark - Segue

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"shouldPerformSegueWithIdentifier: %@", identifier);
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue :%@", segue.identifier);
    FileManagerViewController *fmvc = segue.destinationViewController;
    fmvc.path = self.selectedPath;
}

@end
