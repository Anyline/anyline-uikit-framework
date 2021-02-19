//
//  OpenCVWrapper.h
//  AnylineUIKit
//
//  Created by Mac on 12/10/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

#ifndef OpenCVWrapper_h
#define OpenCVWrapper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject

+(UIImage *) autoContrast:(UIImage *) image;
+(UIImage *) processImageWithOpenCV:(UIImage*) inputImage;
+(UIImage *) autoWBOpenCV:(UIImage *) inputImage;
+(UIImage *) toBlackAndWhite:(UIImage *) inputImage;
+(UIImage *) toGray:(UIImage *) inputImage;

@end

#endif /* OpenCVWrapper_h */
