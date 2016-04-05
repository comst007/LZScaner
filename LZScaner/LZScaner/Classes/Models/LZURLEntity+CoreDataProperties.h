//
//  LZURLEntity+CoreDataProperties.h
//  LZScaner
//
//  Created by comst on 16/4/6.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LZURLEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZURLEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *urlString;
@property (nullable, nonatomic, retain) NSDate *urlDate;

@end

NS_ASSUME_NONNULL_END
