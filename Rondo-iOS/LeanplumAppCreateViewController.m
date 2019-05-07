//
//  LeanplumAppCreateViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/4/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LeanplumAppCreateViewController.h"
#import "LeanplumApp.h"
#import "LeanplumAppPersistence.h"
#import <AVFoundation/AVFoundation.h>

@interface LeanplumAppCreateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *displayNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *appIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *devKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *prodKeyTextField;

@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureMetadataOutput *captureMetadataOutput;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation LeanplumAppCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create App";
}

- (IBAction)createButtonPressed:(id)sender {
    [LeanplumAppPersistence saveLeanplumApp:[self createdApp]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(LeanplumApp *)createdApp {
    LeanplumApp *app = [[LeanplumApp alloc] init];
    app.displayName = self.displayNameTextField.text;
    app.appId = self.appIdTextField.text;
    app.devKey = self.devKeyTextField.text;
    app.prodKey = self.prodKeyTextField.text;
    return app;
}

- (IBAction)useCameraButtonPressed:(id)sender {
    self.session = [AVCaptureSession new];
     self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!backCamera) {
        NSLog(@"Unable to access back camera!");
        return;
    }
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera
                                                                        error:&error];
    if (!error) {
        self.captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    }
    else {
        NSLog(@"Error Unable to initialize back camera: %@", error.localizedDescription);
    }
    
    if ([self.session canAddInput:input] && [self.session canAddOutput:_captureMetadataOutput]) {
        
        [self.session addInput:input];
        [self.session addOutput:_captureMetadataOutput];
        
        dispatch_queue_t dispatchQueue;
        dispatchQueue = dispatch_queue_create("qrcapture_queue", NULL);
        [_captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        [_captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        
        [self setupLivePreview];
    }
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self performSelectorOnMainThread:@selector(autoFillWithJSON:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(stopCapture) withObject:nil waitUntilDone:NO];
        }
    }
}

- (void) stopCapture {
    [self.session  stopRunning];
    _session = nil;
    [self.videoPreviewLayer removeFromSuperlayer];
}

- (void) autoFillWithJSON:(NSString *)qrJson {
    NSData *data = [qrJson dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error) {
        NSString * appId = [json objectForKey:@"app_id"];
        NSString * production = [json objectForKey:@"production"];
        NSString * development = [json objectForKey:@"development"];
        
        if(appId != nil && production != nil && development != nil) {
            self.appIdTextField.text = appId;
            self.prodKeyTextField.text = production;
            self.devKeyTextField.text = development;
            return;
        }
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invaild QRCode"
                                                                   message:@"The QR code must be json of the format {\"app_id\": [id of app], \"production\":[production key], \"development\":[development key]}"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupLivePreview {
    
    self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    if (self.videoPreviewLayer) {
        
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        [self.previewView.layer addSublayer:self.videoPreviewLayer];
        
        
        dispatch_queue_t globalQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(globalQueue, ^{
            [self.session startRunning];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.videoPreviewLayer.frame = self.previewView.bounds;
            });
            
        });
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}

@end
