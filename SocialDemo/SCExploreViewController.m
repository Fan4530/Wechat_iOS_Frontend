#import "SCExploreViewController.h"
#import <MapKit/MapKit.h>
#import "SCLocationManager.h"

#import "SCPost.h"

#import "SCHomeViewController.h"


static NSString * const SCAnnotationIdentifier = @"post.pin";


@interface SCExploreViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@property (strong, nonatomic) NSArray <SCPost *>* posts;
@property (assign, nonatomic) BOOL isUserHasPosts;
@property (strong, nonatomic) CLLocation *center;
@property (assign, nonatomic) CLLocationDistance radius;

@end

@implementation SCExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self reloadPosts];
}

- (void)setupUI
{
    self.title = NSLocalizedString(@"Explore", nil);
    [self.reloadButton setTitle:NSLocalizedString(@"Search This Area", nil) forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(reloadPosts) forControlEvents:UIControlEventTouchUpInside];
    
    [self.reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.reloadButton.layer.cornerRadius = 5;
    [self setupMap];
}

- (void)setupMap
{
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    CLLocationCoordinate2D coordinate = [[SCLocationManager sharedManager] getUserCurrentLocation].coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(3.5, 3.5);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region];
}

- (void)updateMapWithPosts
{
    for (SCPost *post in self.posts) {
        CLLocationCoordinate2D postLocation = post.location.coordinate;
        CLLocationCoordinate2D userLocation = [[SCLocationManager sharedManager] getUserCurrentLocation].coordinate;
        if ((postLocation.latitude == userLocation.latitude) &&
            (postLocation.longitude == userLocation.longitude)) {
            self.isUserHasPosts = YES;
        }
        MKPointAnnotation *anotation = [MKPointAnnotation new];
        [anotation setCoordinate:post.location.coordinate];
        [self.mapView addAnnotation:anotation];
    }
}

- (NSArray<SCPost *> *)postInLocation:(CLLocationCoordinate2D)coordinate
{
    NSMutableArray<SCPost *> *posts = [NSMutableArray new];
    for (SCPost *post in self.posts) {
        CLLocationCoordinate2D postCoordinate = post.location.coordinate;
        if ((fabs(postCoordinate.latitude - coordinate.latitude) <= 0.005) &&
            (fabs(postCoordinate.longitude - coordinate.longitude) <= 0.005)) {
            [posts addObject:post];
        }
    }
    return posts;
}

#pragma mark - action
- (void)loadPosts
{
    CLLocation *location = [[SCLocationManager sharedManager] getUserCurrentLocation];
    [self fetchPostsWithLocation:location];
}

- (void)reloadPosts
{
    CLLocationCoordinate2D centerCoordinate = [self.mapView centerCoordinate];
    self.center = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    CLLocationCoordinate2D topCenterCoordinate = [self.mapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:self.mapView];
    CLLocation *topCenter = [[CLLocation alloc] initWithLatitude:topCenterCoordinate.latitude longitude:topCenterCoordinate.longitude];
    self.radius = [self.center distanceFromLocation:topCenter];
    
    [self fetchPostsWithLocation:self.center];
}

- (void)fetchPostsWithLocation:(CLLocation *)location
{
    
}

- (void)showPostsInMapWithLocation:(CLLocationCoordinate2D)coordinate
{
    NSArray<SCPost *> *posts =[self postInLocation:coordinate];
    if (posts.count == 1) {
        
    }
    else if (posts.count > 1) {
        SCHomeViewController *postsViewController = [[SCHomeViewController alloc] initWithNibName:NSStringFromClass([SCHomeViewController class]) bundle:nil];
        
        [self.navigationController pushViewController:postsViewController animated:YES];
    }
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    [self showPostsInMapWithLocation:view.annotation.coordinate];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = nil;
    if ((annotation == mapView.userLocation) && !self.isUserHasPosts) {
        [mapView.userLocation setTitle:NSLocalizedString(@"You are here", nil)];
    }
    else {
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:SCAnnotationIdentifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:SCAnnotationIdentifier];
            annotationView.image = [UIImage imageNamed:@"Shape"];
            annotationView.canShowCallout = NO;
        }
    }
    return annotationView;
}


@end
