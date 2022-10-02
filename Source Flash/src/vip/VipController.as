package vip
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.GradientText;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.VipSettingAnalyzer;
   import ddt.data.player.SelfInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import vip.data.VipModelInfo;
   import vip.view.RechargeAlertTxt;
   import vip.view.VIPHelpFrame;
   import vip.view.VIPRechargeAlertFrame;
   import vip.view.VipFrame;
   
   public class VipController
   {
      
      private static var _instance:VipController;
      
      private static var useFirst:Boolean = true;
      
      private static var loadComplete:Boolean = false;
      
      public static const VIPStrengthenEx:Number = 0.3;
       
      
      public var VipSettings:Dictionary;
      
      public var info:VipModelInfo;
      
      public var isRechargePoped:Boolean;
      
      private var _vipFrame:VipFrame;
      
      private var _isShow:Boolean;
      
      private var _helpframe:VIPHelpFrame;
      
      private var _rechargeAlertFrame:VIPRechargeAlertFrame;
      
      private var _rechargeAlertLoad:Boolean = false;
      
      public function VipController()
      {
         super();
      }
      
      public static function get instance() : VipController
      {
         if(!_instance)
         {
            _instance = new VipController();
         }
         return _instance;
      }
      
      public function setup(param1:VipSettingAnalyzer) : void
      {
         this.VipSettings = param1.VipSettings;
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            if(PlayerManager.Instance.Self.IsVIP)
            {
               this.showVipFrame();
            }
            else if(this._helpframe == null)
            {
               this._helpframe = ComponentFactory.Instance.creatComponentByStylename("vip.viphelpFrame");
               this._helpframe.openFun = this.showVipFrame;
               this._helpframe.show();
               this._helpframe.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            }
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_VIEW);
            useFirst = false;
         }
      }
      
      public function showRechargeAlert() : void
      {
         var _loc1_:SelfInfo = null;
         var _loc2_:RechargeAlertTxt = null;
         if(loadComplete)
         {
            if(this._rechargeAlertFrame == null)
            {
               this._rechargeAlertFrame = ComponentFactory.Instance.creatComponentByStylename("vip.vipRechargeAlertFrame");
               _loc1_ = PlayerManager.Instance.Self;
               _loc2_ = new RechargeAlertTxt();
               _loc2_.AlertContent = _loc1_.VIPLevel;
               this._rechargeAlertFrame.content = _loc2_;
               this._rechargeAlertFrame.show();
               this._rechargeAlertFrame.addEventListener(FrameEvent.RESPONSE,this.__responseRechargeAlertHandler);
            }
         }
         else if(useFirst)
         {
            this._rechargeAlertLoad = true;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_VIEW);
            useFirst = false;
         }
      }
      
      public function helpframeNull() : void
      {
         if(this._helpframe)
         {
            this._helpframe = null;
         }
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         this._helpframe.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._helpframe.dispose();
         }
      }
      
      protected function __responseRechargeAlertHandler(param1:FrameEvent) : void
      {
         this._rechargeAlertFrame.removeEventListener(FrameEvent.RESPONSE,this.__responseRechargeAlertHandler);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._rechargeAlertFrame.dispose();
         }
         if(this._rechargeAlertFrame)
         {
            this._rechargeAlertFrame = null;
         }
      }
      
      private function showVipFrame() : void
      {
         if(this._vipFrame == null)
         {
            this._vipFrame = ComponentFactory.Instance.creatComponentByStylename("vip.VipFrame");
         }
         this._vipFrame.show();
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.VIP_VIEW)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            if(this._rechargeAlertLoad)
            {
               this.showRechargeAlert();
            }
            else
            {
               this.show();
            }
         }
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.VIP_VIEW)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      public function sendOpenVip(param1:String, param2:int) : void
      {
         SocketManager.Instance.out.sendOpenVip(param1,param2);
      }
      
      public function hide() : void
      {
         if(this._vipFrame != null)
         {
            this._vipFrame.dispose();
         }
         this._vipFrame = null;
      }
      
      public function getVipNameTxt(param1:int = -1, param2:int = 1) : GradientText
      {
         var _loc3_:GradientText = null;
         switch(param2)
         {
            case 0:
               throw new Error("会员类型错误,不能为非会员玩家创建会员字体.");
            case 1:
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("vipName");
               break;
            case 2:
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("vipName");
         }
         if(_loc3_)
         {
            if(param1 != -1)
            {
               _loc3_.textField.width = param1;
            }
            else
            {
               _loc3_.textField.autoSize = "left";
            }
            return _loc3_;
         }
         return ComponentFactory.Instance.creatComponentByStylename("vipName");
      }
   }
}
