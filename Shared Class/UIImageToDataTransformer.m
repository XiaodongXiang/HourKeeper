//
//  UIImageToDataTransformer.m
//  HoursKeeper
//
//  Created by humingjing on 15/7/30.
//
//

#import "UIImageToDataTransformer.h"

@implementation UIImageToDataTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSData class];
}

- (id)transformedValue:(id)value {
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value {
    return [[UIImage alloc] initWithData:value];
}

@end
