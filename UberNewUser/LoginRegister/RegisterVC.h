//
//  RegisterVC.h
//  Uber
//
//  Created by Elluminati - macbook on 23/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import "BaseVC.h"
#import "JVFloatLabeledTextField.h"

@interface RegisterVC : BaseVC<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
{

}
///// Outlets

@property (weak, nonatomic) IBOutlet GIDSignInButton *btngoogleplus;
@property (weak, nonatomic) IBOutlet UIButton *btnfacebook;
@property ( nonatomic) bool maleBtnSelected;
@property ( nonatomic) bool femaleBtnSelected;
@property ( nonatomic) bool googlemaleBtnSelected;
@property ( nonatomic) bool googlefemaleBtnSelected;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txtFirstName;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txtLastName;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txtEmail;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txtNumber;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txtPassword;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txtAddress;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txtBio;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txtZipCode;
@property (weak, nonatomic) IBOutlet UIButton *btnProPic;
@property (weak, nonatomic) IBOutlet UIView *viewForPicker;
@property (weak, nonatomic) IBOutlet UIImageView *imgProPic;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *viewForEmailInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnTerms;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectCountry;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnTerm;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectCountry;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnemailinfo;

/////// labels
@property (weak, nonatomic) IBOutlet UILabel *lblEmailInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblenteryourphonenumber;
@property (weak, nonatomic) IBOutlet UIButton *btnclick_edit_profile;
@property (weak, nonatomic) IBOutlet UILabel *lblTaxiappz;
@property (weak, nonatomic) IBOutlet UIButton *btn_otpsubmit;
@property (weak, nonatomic) IBOutlet UILabel *lblsitback;
@property (weak, nonatomic) IBOutlet UILabel *lblplsenterotp;
@property (weak, nonatomic) IBOutlet UIButton *btnresendotp;

////// Actions
- (IBAction)pickerCancelBtnPressed:(id)sender;
- (IBAction)pickerDoneBtnPressed:(id)sender;
- (IBAction)fbbtnPressed:(id)sender;
- (IBAction)proPicBtnPressed:(id)sender;
- (IBAction)selectCountryBtnPressed:(id)sender;
- (IBAction)googleBtnPressed:(id)sender;
- (IBAction)nextBtnPressed:(id)sender;
- (IBAction)btnEmailInfoClick:(id)sender;
- (IBAction)checkBoxBtnPressed:(id)sender;
- (IBAction)termsBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnNav_Register;
@property(weak, nonatomic) IBOutlet UIView *viewForOTP;
@property(weak, nonatomic) IBOutlet JVFloatLabeledTextField *txtOTP;
@property (weak, nonatomic) IBOutlet UIView *viewforEmail;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *viewforemailEmailtfd;
@property (weak, nonatomic) IBOutlet UILabel *enteryouremaillbl;

@property(strong, nonatomic) IBOutlet UIView *viewforPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnSocialSelectCountry;
@property(strong, nonatomic) IBOutlet JVFloatLabeledTextField *txtSocialPhone;

@property (nonatomic, weak) IBOutlet UITableView *tblCountry;
@property (nonatomic, weak) IBOutlet JVFloatLabeledTextField *txtSearchText;
@property (nonatomic, weak) IBOutlet UIView *viewforCountrySearch;

//Natarajan

@property (weak, nonatomic) IBOutlet UILabel *genderLbl;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UILabel *maleLbl;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UILabel *femaleLbl;

@property(nonatomic, weak) IBOutlet UIView *googlephonenumbergenderview;
@property(nonatomic, weak) IBOutlet UIButton *googlephonenumbercountrycodeBtn;
@property(nonatomic, weak) IBOutlet UITextField *googlephonenumberTfd;
@property (weak, nonatomic) IBOutlet UILabel *googlegenderLbl;
@property (weak, nonatomic) IBOutlet UIButton *googlemaleBtn;
@property (weak, nonatomic) IBOutlet UILabel *googlemaleLbl;
@property (weak, nonatomic) IBOutlet UIButton *googlefemaleBtn;
@property (weak, nonatomic) IBOutlet UILabel *googlefemaleLbl;

@end
