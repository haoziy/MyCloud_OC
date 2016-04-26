
#import "BaseHiddenTabbarViewController.h"
#import "DeviceModel.h"
#import "VoiceDecoder.h"
#import "voiceEncoder.h"
#import "MNGSearchDeviceForConfigNetViewController.h"

@interface MNGDeviceNetConfigViewController : BaseHiddenTabbarViewController
{
    VoiceRecog *recog;
    VoicePlayer *player;
    
}
@property(nonatomic,strong)DeviceModel *deviceModel;

@property(nonatomic,copy)NSString *serverIp;
@property(nonatomic,copy)NSString *serverPort;

@property(nonatomic,assign)DeviceConfigEnteryWay enterWay;
- (void) onRecognizerStart;
- (void) onRecognizerEnd:(int)_result data:(char *)_data dataLen:(int)_dataLen;

@end
