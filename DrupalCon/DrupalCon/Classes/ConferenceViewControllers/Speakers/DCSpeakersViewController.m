//
//  The MIT License (MIT)
//  Copyright (c) 2014 Lemberg Solutions Limited
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//   The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "DCSpeakersViewController.h"
#import "AppDelegate.h"
#import "DCSpeakersDetailViewController.h"
#import "DCSpeakerCell.h"
#import "DCMainProxy+Additions.h"
#import "DCSpeaker+DC.h"
#import "UIImageView+WebCache.h"

@interface DCSpeakersViewController ()

@property (nonatomic, weak) IBOutlet UITableView * speakersTbl;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation DCSpeakersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];

}


#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self reload];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - UITableView delegate/datasourse methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdSpeaker = @"DetailCellIdentifierSpeaker";
    DCSpeakerCell *_cell = (DCSpeakerCell*)[tableView dequeueReusableCellWithIdentifier: cellIdSpeaker];
    
    DCSpeaker * speaker = [self.fetchedResultsController objectAtIndexPath:indexPath];//_speakers[indexPath.row];
    
    [_cell.nameLbl setText:speaker.name];
    
    [_cell.positionTitleLbl setText: [self positionTitleForSpeaker:speaker]];
    [_cell.pictureImg sd_setImageWithURL:[NSURL URLWithString:speaker.avatarPath]
                        placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [_cell setNeedsDisplay];
                                   });
                               }];
    return _cell;
}

- (NSString *)positionTitleForSpeaker:(DCSpeaker *)speaker
{
    NSString *organisationName = speaker.organizationName;
    NSString *jobTitle = speaker.jobTitle;
    if ([jobTitle length] && [organisationName length]) {
        return [NSString stringWithFormat:@"%@ / %@", organisationName, jobTitle];
    }
    if (![jobTitle length]) {
        return organisationName;
    }
    
    return jobTitle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DCSpeakersDetailViewController * detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"SpeakersDetailViewController"];
    [detailController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    detailController.speaker = _speakers[indexPath.row];
    detailController.closeCallback = ^{
        [self.speakersTbl reloadData];
    };
    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] window].rootViewController presentViewController:detailController animated:YES completion:nil];

}

- (NSSortDescriptor *)sortDescriptor {
    NSSortDescriptor *sortLastName = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *lastName1 = (NSString *)obj1;
        NSString *lastName2 = (NSString *)obj2;
        if ([lastName1 length] == 0 && [lastName2 length] == 0) {
            return NSOrderedSame;
        }
        if ([lastName1 length] == 0) {
            return NSOrderedDescending;
        }
        if ([lastName2 length] == 0) {
            return NSOrderedAscending;
        }
        
        
        return [lastName1 compare:lastName2 options:NSCaseInsensitiveSearch];
    }];
    return sortLastName;
}

- (void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DCSpeaker"];
     NSSortDescriptor *sectionKeyDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sectionKey" ascending:YES] ;
    NSSortDescriptor *firstNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES] ;
    NSSortDescriptor *lastNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
    
    request.sortDescriptors = @[sectionKeyDescriptor, firstNameDescriptor, lastNameDescriptor];
    
    NSPredicate *predicate = nil;
    if (self.searchBar.text.length)
        predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", self.searchBar.text];
    
    request.predicate = predicate;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                    managedObjectContext:[DCMainProxy sharedProxy].workContext
                                                                      sectionNameKeyPath:@"sectionKey"
                                                                               cacheName:nil];
//    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error)
        NSLog(@"%@", error);
    
    [self.speakersTbl reloadData];
}


@end
