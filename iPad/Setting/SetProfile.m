//
//  SetProfile.m
//  HoursKeeper
//
//  Created by xy_dev on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetProfile.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "FileController.h"
#import "Profile.h"
#import "AppDelegate_iPad.h"



@interface SetProfile ()
{
    int ifRemovePhoto;
    UITextField *currentField;
	BOOL keyboardIsShown;
}
@end




@implementation SetProfile


@synthesize popoverController;

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.titleLabel.font = appDelegate.naviFont2;
    saveButton.frame = CGRectMake(0, 0, 48, 30);
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveandback_Btn) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:NO button:saveButton];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 30);
    [backBtn setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    backBtn.titleLabel.font = appDelegate.naviFont;
//    [backBtn setTitle:@"Settings" forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(cancel_Btn) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backBtn];
    
    [appDelegate setNaviGationTittle:self with:300 high:44 tittle:@"Profile"];
    
    

    
    [self.scrollView setContentSize:CGSizeMake(500,480)];
    
    
	NSString *headpath = [[FileController documentPath] stringByAppendingPathComponent:@"head.png"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:headpath])
    {
		[self.imageButton setBackgroundImage:[UIImage imageWithContentsOfFile:headpath] forState:UIControlStateNormal];
	}
    else
    {
        [self.imageButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    keyboardIsShown = NO;
    
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSManagedObjectModel *model = [appDelegate managedObjectModel];
	NSEntityDescription *profile = [[model entitiesByName] valueForKey:@"Profile"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:profile];
	NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
	if ([results count] > 0)
    {
		Profile *myProfile = [results objectAtIndex:0];
		self.nameField.text = myProfile.name;
		self.companyField.text = myProfile.company;
		self.phoneField.text = myProfile.phone;
		self.faxField.text = myProfile.fax;
		self.emailField.text = myProfile.email;
		self.streetField.text = myProfile.street;
		self.cityField.text = myProfile.city;
		self.stateField.text = myProfile.state;
		self.zipField.text = myProfile.zip;
	}
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
}

- (void) viewWillAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    NSString *filepath = [[FileController documentPath] stringByAppendingPathComponent:@"head1.png"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
		[[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
	}
}

-(void)dealloc
{
    
    if (popoverController != nil)
    {
        if (popoverController.isPopoverVisible == YES)
        {
            [popoverController dismissPopoverAnimated:YES];
        }
    }
    
    
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}





-(void)cancel_Btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveandback_Btn
{
    if (self.imageButton.currentBackgroundImage != nil)
    {
        NSString *filepath = [[FileController documentPath] stringByAppendingPathComponent:@"head1.png"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
        {
            NSString *headpath = [[FileController documentPath] stringByAppendingPathComponent:@"head.png"];
            if([[NSFileManager defaultManager] fileExistsAtPath:headpath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:headpath error:nil];
            }
            [[NSFileManager defaultManager] moveItemAtPath:filepath toPath:headpath error:nil];
        }
    }
	else
    {
        NSString *filepath = [[FileController documentPath] stringByAppendingPathComponent:@"head1.png"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
        }
        
        NSString *headpath = [[FileController documentPath] stringByAppendingPathComponent:@"head.png"];
        if([[NSFileManager defaultManager] fileExistsAtPath:headpath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:headpath error:nil];
        }
    }
    
    
	AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSManagedObjectModel *model = [appDelegate managedObjectModel];
	NSEntityDescription *profile = [[model entitiesByName] valueForKey:@"Profile"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:profile];
    
	NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
	if ([results count] > 0)
    {
		Profile *myProfile = [results objectAtIndex:0];
		myProfile.name = self.nameField.text;
		myProfile.company = self.companyField.text;
		myProfile.phone = self.phoneField.text;
		myProfile.fax = self.faxField.text;
		myProfile.email = self.emailField.text;
		myProfile.street = self.streetField.text;
		myProfile.city = self.cityField.text;
		myProfile.state = self.stateField.text;
		myProfile.zip = self.zipField.text;
	}
    else
    {
		Profile *newProfile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context];
		newProfile.name = self.nameField.text;
		newProfile.company = self.companyField.text;
		newProfile.phone = self.phoneField.text;
		newProfile.fax = self.faxField.text;
		newProfile.email = self.emailField.text;
		newProfile.street = self.streetField.text;
		newProfile.city = self.cityField.text;
		newProfile.state = self.stateField.text;
		newProfile.zip = self.zipField.text;
	}
	[context save:nil];
    
    [appDelegate.mainView reflashLeftPageView];
    
    [self.navigationController popViewControllerAnimated:YES];
}


//加载图片
- (IBAction)clickImage_presentActionSheet:(id)sender
{
    
    [currentField resignFirstResponder];
    
    
    UIActionSheet *actionSheet;
    
    if (self.imageButton.currentBackgroundImage != nil)
    {
       actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Choose Existing Photo" otherButtonTitles:@"Remove Photo",nil];
        ifRemovePhoto = 1;
        
        actionSheet.destructiveButtonIndex = 1;
    }
    else
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Choose Existing Photo" otherButtonTitles:nil];
        ifRemovePhoto = 0;
    }
    
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.view];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    appDelegate.close_PopView = actionSheet;
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *array = [[NSArray alloc] initWithObjects:actionSheet, [NSNumber numberWithInteger:buttonIndex],nil];
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
    [self performSelector:@selector(doActionSheet:) withObject:array afterDelay:0];
}

-(void)doActionSheet:(NSArray *)array
{
    NSNumber *num = [array objectAtIndex:1];
    NSInteger buttonIndex = num.integerValue;
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    if (buttonIndex == 0)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            appDelegate.m_pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            appDelegate.m_pickerController.delegate = self;
            appDelegate.m_pickerController.allowsEditing = YES;
            
            appDelegate.m_pickerController.preferredContentSize = CGSizeMake(550, 550);
            
            if (popoverController != nil)
            {
                popoverController = nil;
            }
            popoverController = [[UIPopoverController alloc] initWithContentViewController:appDelegate.m_pickerController];
            
            [popoverController presentPopoverFromRect:self.imageButton.frame inView:self.imageButton.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Photo Library Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alertView show];
            
            appDelegate.close_PopView = alertView;
            
        }
        
    }
    else if (buttonIndex == 1 && ifRemovePhoto == 1)
    {
        [self.imageButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
}



- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqual:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSString *filepath = [[FileController documentPath] stringByAppendingPathComponent:@"head1.png"];
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:filepath atomically:NO];
        [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if ([popoverController isPopoverVisible])
    {
        [popoverController dismissPopoverAnimated:YES];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}




- (void) textFieldDidBeginEditing:(UITextField *)textField
{
	currentField = textField;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
	return NO;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
	if (keyboardIsShown) return;
	
	CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	self.scrollView.frame = viewFrame;
    
    [self.scrollView setContentSize:CGSizeMake(500,self.view.frame.size.height+140)];
	CGRect textFieldRect = CGRectMake(currentField.frame.origin.x, currentField.frame.origin.y+350, currentField.frame.size.width, currentField.frame.size.height);
	[self.scrollView scrollRectToVisible:textFieldRect animated:YES];
    
	keyboardIsShown = YES;
}

- (void)keyboardDidHide:(NSNotification *)notification
{
	CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.frame = viewFrame;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.scrollView setContentSize:CGSizeMake(500,self.view.frame.size.height+80)];
    
	keyboardIsShown = NO;
}






- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (keyboardIsShown == NO)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}




@end


