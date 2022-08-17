//
//  ViewController.m
//  XMPMetadata
//
//  Created by zhangjiahao.me on 2022/8/17.
//

#import "ViewController.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *key = [NSString stringWithFormat:@"%@:%@", kCGImageMetadataPrefixExif, kCGImagePropertyExifVersion];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xmp_test" ofType:@"png"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSLog(@"%@", fileURL);
    
    NSString *destinationPath = [[NSBundle mainBundle] pathForResource:@"xmp_test_meta" ofType:@"png"];
    NSURL *destinationURL = [NSURL fileURLWithPath:destinationPath];
    NSLog(@"%@", destinationURL);
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge  CFURLRef)destinationURL, kUTTypePNG, 1, NULL);
    
    NSString *ev = @"zjh_test";
    CGImageMetadataTagRef tag = CGImageMetadataTagCreate(kCGImageMetadataNamespaceExif, kCGImageMetadataPrefixExif, kCGImagePropertyExifVersion, kCGImageMetadataTypeString, (__bridge  CFStringRef)ev);
    CGMutableImageMetadataRef metadataRef = CGImageMetadataCreateMutable();
    CGImageMetadataSetTagWithPath(metadataRef, nil, (__bridge CFStringRef)key, tag);
    CGImageSourceRef sourceRef = CGImageSourceCreateWithURL((__bridge CFURLRef)fileURL, NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
    
    CGImageDestinationAddImageAndMetadata(destination, imageRef, metadataRef, NULL);
    CGImageDestinationFinalize(destination);
    
    
    
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)fileURL, NULL);
    if (source) {
        NSDictionary* props = (__bridge_transfer NSDictionary*) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        NSLog(@"%@", props);
        
        CGImageMetadataRef imageMetadataRef = CGImageSourceCopyMetadataAtIndex(source, 0, NULL);
        NSArray *metadata = CFBridgingRelease(CGImageMetadataCopyTags(imageMetadataRef));
        NSLog(@"%@", metadata);
        
        NSString *result = CFBridgingRelease(CGImageMetadataCopyStringValueWithPath(imageMetadataRef, NULL, (__bridge CFStringRef)key));
        NSLog(@"%@", result);
        
    }
}


@end
