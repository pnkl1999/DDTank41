package roulette
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class LeftGunRouletteManager extends EventDispatcher
   {
      
      private static var _instance:LeftGunRouletteManager = null;
      
      private static const TYPE_ROULETTE:int = 1;
      
      private static const TYPEI_ISOPEN:int = 1;
      
      private static const MAX_LENGTH:int = 20;
       
      
      private var _gunBtn:MovieClip;
      
      private var _rouletteView:RouletteFrame;
      
      private var _reward:String;
      
      private var _alertAward:BaseAlerFrame;
      
      private var _helpPage:HelpFrame;
      
      public var IsOpen:Boolean;
      
      public var ArrNum:Array;
      
      private var _isvisible:Boolean = true;
      
      private var isShow:Boolean;
      
      public function LeftGunRouletteManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : LeftGunRouletteManager
      {
         if(_instance == null)
         {
            _instance = new LeftGunRouletteManager();
         }
         return _instance;
      }
      
      public function init() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LEFT_GUN_ROULETTE,this.__openRoulett);
      }
      
      private function __openRoulett(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc2_ = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         switch(_loc3_)
         {
            case TYPE_ROULETTE:
               _loc4_ = _loc2_.readInt();
               switch(_loc4_)
               {
                  case TYPEI_ISOPEN:
                     this.IsOpen = _loc2_.readBoolean();
                     if(this.IsOpen)
                     {
                        _loc5_ = _loc2_.readInt();
                        _loc6_ = _loc2_.readUTF();
                        dispatchEvent(new RouletteFrameEvent(RouletteFrameEvent.LEFTGUN_ENABLE));
                        if(_loc5_ <= 0)
                        {
                           this._reward = _loc6_;
                           this._isvisible = false;
                           return;
                        }
                        this._isvisible = true;
                        this.ArrNum = new Array();
                        _loc7_ = 0;
                        while(_loc7_ < MAX_LENGTH)
                        {
                           _loc8_ = _loc2_.readInt();
                           this.ArrNum.push(_loc8_);
                           _loc7_++;
                        }
                        break;
                     }
                     this.hideGunButton();
                     break;
               }
         }
      }
      
      public function showLeftGunRoulette() : *
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LEFTGUNROULETTE,true);
      }
      
      public function hideLeftGunRoulette() : *
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LEFTGUNROULETTE,false);
      }
      
      public function showGunButton() : void
      {
         if(this._gunBtn && this._gunBtn.parent)
         {
            return;
         }
         this._gunBtn = ClassUtils.CreatInstance("asset.roulette.gun") as MovieClip;
         PositionUtils.setPos(this._gunBtn,"roulette.gun.pos");
         this._gunBtn.buttonMode = true;
         this._gunBtn.addEventListener(MouseEvent.CLICK,this.__onGunBtnClick);
         LayerManager.Instance.addToLayer(this._gunBtn,LayerManager.GAME_DYNAMIC_LAYER,false,0,false);
         this._gunBtn.parent.setChildIndex(this._gunBtn,0);
      }
      
      public function hideGunButton() : void
      {
         SoundManager.instance.playMusic("062");
         if(this._alertAward)
         {
            this._alertAward.removeEventListener(FrameEvent.RESPONSE,this.__goRenewal);
            this._alertAward.dispose();
            this._alertAward = null;
         }
         if(this._rouletteView)
         {
            this._rouletteView.removeEventListener(RouletteFrameEvent.ROULETTE_VISIBLE,this.__isVisible);
            this._rouletteView.removeEventListener(RouletteFrameEvent.BUTTON_CLICK,this.__buttonClick);
            this._rouletteView.dispose();
            this._rouletteView = null;
         }
         if(this._gunBtn)
         {
            if(this._gunBtn.parent)
            {
               this._gunBtn.parent.removeChild(this._gunBtn);
            }
            this._gunBtn.removeEventListener(MouseEvent.CLICK,this.__onGunBtnClick);
            this._gunBtn = null;
         }
         if(this._helpPage)
         {
            ObjectUtils.disposeObject(this._helpPage);
            this._helpPage = null;
         }
      }
      
      private function removeGunBtn() : void
      {
         if(this._gunBtn)
         {
            ObjectUtils.disposeObject(this._gunBtn);
         }
         this._gunBtn = null;
      }
      
      public function showTurnplate() : void
      {
         if(this._isvisible)
         {
            SoundManager.instance.playMusic("140");
            this.createFrame();
         }
         else
         {
            this.showTipFrame(this._reward);
         }
      }
      
      private function showTipFrame(param1:String) : void
      {
         var _loc2_:String = LanguageMgr.GetTranslation("tank.roulette.tipInfo",param1);
         this._alertAward = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this._alertAward.moveEnable = false;
         this._alertAward.addEventListener(FrameEvent.RESPONSE,this.__goRenewal);
      }
      
      public function showhelpFrame() : void
      {
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.roulette.helpBG");
         this._helpPage = ComponentFactory.Instance.creat("roulette.helpFrame");
         this._helpPage.setView(_loc1_);
         this._helpPage.titleText = LanguageMgr.GetTranslation("tank.roulette.helpView.tltle");
         LayerManager.Instance.addToLayer(this._helpPage,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
      }
      
      private function getReward(param1:String) : String
      {
         var _loc6_:String = null;
         var _loc2_:Array = param1.split(".");
         var _loc3_:int = int(_loc2_[0]);
         var _loc4_:int = int(_loc2_[1]);
         var _loc5_:int = _loc3_ - 1;
         if(_loc5_ == 0)
         {
            _loc6_ = _loc4_ + "0" + "%";
         }
         else
         {
            _loc6_ = _loc5_.toString() + _loc4_.toString() + "0" + "%";
         }
         return _loc6_;
      }
      
      private function createFrame() : void
      {
         if(!this.isShow)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ROULETTE);
         }
         else
         {
            if(this._rouletteView == null)
            {
               this._rouletteView = new RouletteFrame();
            }
            this._rouletteView.addEventListener(RouletteFrameEvent.ROULETTE_VISIBLE,this.__isVisible);
            this._rouletteView.addEventListener(RouletteFrameEvent.BUTTON_CLICK,this.__buttonClick);
            LayerManager.Instance.addToLayer(this._rouletteView,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
            PositionUtils.setPos(this._rouletteView,"asset.rouletteFramePos");
         }
      }
      
      public function setRouletteFramenull() : void
      {
         this._rouletteView = null;
      }
      
      private function __onSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
      }
      
      private function __onUIComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.ROULETTE)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleSmallLoading.Instance.hide();
            this.isShow = true;
            this.createFrame();
         }
      }
      
      private function __onUIProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.ROULETTE)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __goRenewal(param1:FrameEvent) : void
      {
         if(this._alertAward)
         {
            this._alertAward.removeEventListener(FrameEvent.RESPONSE,this.__goRenewal);
         }
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               LeavePageManager.leaveToFillPath();
         }
         this._alertAward.dispose();
         if(this._alertAward.parent)
         {
            this._alertAward.parent.removeChild(this._alertAward);
         }
         this._alertAward = null;
      }
      
      private function __isVisible(param1:RouletteFrameEvent) : void
      {
         this._isvisible = false;
         this._reward = param1.reward;
      }
      
      private function __buttonClick(param1:RouletteFrameEvent) : void
      {
         this.showTipFrame(this._reward);
      }
      
      private function __onGunBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.showTurnplate();
      }
   }
}
