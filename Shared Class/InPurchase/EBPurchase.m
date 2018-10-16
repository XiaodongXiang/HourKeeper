
#import "EBPurchase.h"
#import "AppDelegate_Shared.h"



@implementation EBPurchase


@synthesize delegate;
@synthesize validProduct;



//检查是否有此购买的商品
-(bool) requestProduct:(NSString*)productId 
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (productId != nil)
    {
        NSLog(@"EBPurchase requestProduct: %@", productId);
        
        if ([SKPaymentQueue canMakePayments])
        {
            SKProductsRequest *prodRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productId]];
            prodRequest.delegate = self;
            [prodRequest start];
            
            return YES;
        }
        else
        {
            NSLog(@"EBPurchase requestProduct: IAP Disabled");
            [appDelegate hideActiviIndort];
            
            return NO;
        }
    }
    else
    {
        NSLog(@"EBPurchase requestProduct: productId = NIL");
        [appDelegate hideActiviIndort];
        
        return NO;
    }
}


//购买
-(bool) purchaseProduct:(SKProduct*)requestedProduct 
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (requestedProduct != nil)
    {
        NSLog(@"EBPurchase purchaseProduct: %@", requestedProduct.productIdentifier);
        
        if ([SKPaymentQueue canMakePayments])
        {
            SKPayment *paymentRequest = [SKPayment paymentWithProduct:requestedProduct]; 
            
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            
            [[SKPaymentQueue defaultQueue] addPayment:paymentRequest];
            
            return YES;
        }
        else
        {
            NSLog(@"EBPurchase purchaseProduct: IAP Disabled");
            [appDelegate hideActiviIndort];
            
            return NO;
        }
    }
    else
    {
        NSLog(@"EBPurchase purchaseProduct: SKProduct = NIL");
        [appDelegate hideActiviIndort];
        
        return NO;
    }
}


//恢复购买
-(bool) restorePurchase 
{
    NSLog(@"EBPurchase restorePurchase");
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    if ([SKPaymentQueue canMakePayments])
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        
        return YES;
    }
    else
    {
        [appDelegate hideActiviIndort];
        
        return NO;
    }
}









#pragma mark -
#pragma mark SKProductsRequestDelegate Methods

// Store Kit returns a response from an SKProductsRequest.   查询商品回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	self.validProduct = nil;
    
	int count = (int)[response.products count];
	if (count>0)
    {
		self.validProduct = [response.products objectAtIndex:0];
	}
    //有商品了，设置商品的信息
	if (self.validProduct)
    {
		[delegate requestedProduct:self identifier:self.validProduct.productIdentifier name:self.validProduct.localizedTitle price:[self.validProduct.price stringValue] description:self.validProduct.localizedDescription];
	}
    else
    {
		[delegate requestedProduct:self identifier:nil name:nil price:nil description:nil];
    }
}








#pragma mark -
#pragma mark SKPaymentTransactionObserver Methods

// The transaction status of the SKPaymentQueue is sent here.  新交易时被创建，或交易更新时被调用
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for(SKPaymentTransaction *transaction in transactions)
    {
		switch (transaction.transactionState)
        {
			case SKPaymentTransactionStatePurchasing:
				break;
				
			case SKPaymentTransactionStatePurchased:
                
                [delegate successfulPurchase:self identifier:transaction.payment.productIdentifier receipt:nil];
				[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
				break;
				
			case SKPaymentTransactionStateRestored:
				
                [delegate successfulPurchase:self identifier:transaction.payment.productIdentifier receipt:nil];
				[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
				break;
				
			case SKPaymentTransactionStateFailed:
				
				if (transaction.error.code != SKErrorPaymentCancelled)
                {
                    [delegate failedPurchase:self error:transaction.error.code message:transaction.error.localizedDescription];
				}
				[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
				break;
            case SKPaymentTransactionStateDeferred:
                break;
		}
	}
}








// Called when one or more transactions have been removed from the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"EBPurchase removedTransactions");
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideActiviIndort];
}

// Called when SKPaymentQueue has finished sending restored transactions.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"EBPurchase paymentQueueRestoreCompletedTransactionsFinished");
    
    if ([queue.transactions count] == 0)
    {
        NSLog(@"EBPurchase restore queue.transactions count == 0");
        
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
        
        [delegate incompleteRestore:self];
    }
    else
    {
        NSLog(@"EBPurchase restore queue.transactions available");
        
        for(SKPaymentTransaction *transaction in queue.transactions)
        {
            NSLog(@"EBPurchase restore queue.transactions - transaction data found");
            
            [delegate successfulPurchase:self identifier:transaction.payment.productIdentifier receipt:nil];
        }
    }
}

// Called if an error occurred while restoring transactions.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"EBPurchase restoreCompletedTransactionsFailedWithError");

    [delegate failedRestore:self error:error.code message:error.localizedDescription];
}






#pragma mark - Internal Methods & Events




@end
