//
//  LZURLTableViewController.m
//  LZScaner
//
//  Created by comst on 16/4/6.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZURLTableViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "LZURLEntity+CoreDataProperties.h"
#import "UIView+LZFrame.h"
#import "LZURLCell.h"

@interface LZURLTableViewController ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchVC;
@end

@implementation LZURLTableViewController

+ (instancetype)urlTableViewController{
    
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"LZURL" bundle:[NSBundle mainBundle]];
    
    return [SB instantiateViewControllerWithIdentifier:@"LZURLVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseConfig];
    [self configFetchVC];
    [self configTableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)baseConfig{
    self.navigationItem.title = @"Scan History";
    
}

- (void)configTableView{
    self.tableView.backgroundColor = [UIColor colorWithRed:64 / 255.0 green:64 / 255.0 blue:64 / 255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[LZURLCell class] forCellReuseIdentifier:@"LZURLCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)configFetchVC{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LZURLEntity"];
    
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"urlDate" ascending:YES];
    
    request.sortDescriptors = @[sortDes];
    
    self.fetchVC = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[AppDelegate appDelegate].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchVC.delegate = self;
    
    [self.fetchVC performFetch:nil];
}


#pragma mark - fetchVC delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = [self.fetchVC.sections count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchVC.sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZURLCell"];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LZURLEntity *selectItem = [self.fetchVC objectAtIndexPath:indexPath];
        
        [[AppDelegate appDelegate].managedObjectContext deleteObject:selectItem];
        [[AppDelegate appDelegate] saveContext];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     LZURLEntity *selectItem = [self.fetchVC objectAtIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:selectItem.urlString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LZURLEntity *item =  (LZURLEntity *)[self.fetchVC objectAtIndexPath:indexPath];
    cell.textLabel.text = item.urlString;
}

@end
