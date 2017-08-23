
#import "SCHomeViewController.h"
#import "SCPost.h"
#import "SCHomeTableViewCell.h"

static NSString * const SCHomeCellIdentifier = @"homeCellIdentifier";

@interface SCHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray<SCPost *> *posts;

@end

@implementation SCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupNavigationBar];
    [self loadPosts];
}

#pragma mark -- load data
- (void)loadPosts
{
    SCPost *post1 = [SCPost new];
    post1.name = @"Jonathan";
    post1.message = @"Hi, my name is Jonathan.";
    SCPost *post2 = [SCPost new];
    post2.name = @"Steve";
    post2.message = @"Hi, nice to meet you!";
    SCPost *post3 = [SCPost new];
    post3.name = @"Jorge";
    post3.message = @"Do we have class today?";
    self.posts = @[post1, post2, post3];
    [self.tableView reloadData];
}

#pragma mark -- setup UI
- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SCHomeTableViewCell class]) bundle:nil] forCellReuseIdentifier:SCHomeCellIdentifier];
}

- (void)setupNavigationBar
{
    self.title = NSLocalizedString(@"Home", nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PostEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(showCreatePostPage)];
}

#pragma mark -- Action
- (void)showCreatePostPage
{
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCHomeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SCHomeCellIdentifier forIndexPath:indexPath];
    [cell loadCellWithPost:self.posts[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SCHomeTableViewCell cellHeight];
}

@end


