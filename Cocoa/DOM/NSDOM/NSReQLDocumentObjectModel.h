//
//  NSReQLDocumentObjectModel.h
//  MastryAdmin
//
//  Created by Joe Moulton on 6/7/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDocumentObjectModel.h"

//#import "NSJSONDocumentObjectModel.h"

NS_ASSUME_NONNULL_BEGIN

#define NSReQLDOM NSReQLDocumentObjectModel

@interface NSReQLDocumentObjectModel : NSDocumentObjectModel <NSDocumentStoreQuery>

@end

NS_ASSUME_NONNULL_END
