
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol EBPurchaseDelegate;

@interface EBPurchase : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    id<EBPurchaseDelegate> __weak delegate;
    //有效的商品
    SKProduct *validProduct;
}

@property(weak) id<EBPurchaseDelegate> delegate;
@property (nonatomic, strong) SKProduct *validProduct;

-(bool) requestProduct:(NSString*)productId;
-(bool) purchaseProduct:(SKProduct*)requestedProduct;
-(bool) restorePurchase;

@end





@protocol EBPurchaseDelegate<NSObject>

@optional

-(void) requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription;

-(void) successfulPurchase:(EBPurchase*)ebp identifier:(NSString*)productId receipt:(NSData*)transactionReceipt;

-(void) failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage;

-(void) incompleteRestore:(EBPurchase*)ebp;

-(void) failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage;

@end
