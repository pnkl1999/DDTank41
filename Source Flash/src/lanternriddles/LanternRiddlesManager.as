package lanternriddles
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatInputView;
   //import ddtActivityIcon.DdtActivityIconManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import lanternriddles.data.LanternDataAnalyzer;
   import lanternriddles.data.LanternriddlesPackageType;
   import lanternriddles.event.LanternEvent;
   import lanternriddles.view.LanternRiddlesView;
   import road7th.comm.PackageIn;
   
   public class LanternRiddlesManager extends EventDispatcher
   {
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private static var _instance:LanternRiddlesManager;
       
      
      private var _isBegin:Boolean;
      
      private var _lanternView:LanternRiddlesView;
      
      private var _questionInfo:Object;
      
      public function LanternRiddlesManager()
      {
         super();
      }
      
      public static function get instance() : LanternRiddlesManager
      {
         if(!_instance)
         {
            _instance = new LanternRiddlesManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         //DdtActivityIconManager.Instance.addEventListener(LanternEvent.LANTERN_SETTIME,this.__onSetLanternTime);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LANTERNRIDDLES_BEGIN,this.__onAddLanternIcon);
      }
      
      protected function __onAddLanternIcon(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         var _loc4_:CrazyTankSocketEvent = null;
         switch(_loc3_)
         {
            case LanternriddlesPackageType.LANTERNRIDDLES_BEGIN:
               this.openOrclose(_loc2_);
               break;
            case LanternriddlesPackageType.LANTERNRIDDLES_QUESTION:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LANTERNRIDDLES_QUESTION,_loc2_);
               break;
            case LanternriddlesPackageType.LANTERNRIDDLES_RANKINFO:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LANTERNRIDDLES_RANKINFO,_loc2_);
               break;
            case LanternriddlesPackageType.LANTERNRIDDLES_SKILL:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LANTERNRIDDLES_SKILL,_loc2_);
               break;
            case LanternriddlesPackageType.LANTERNRIDDLES_ANSWERRESULT:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LANTERNRIDDLES_ANSWERRESULT,_loc2_);
               break;
            case LanternriddlesPackageType.LANTERNRIDDLES_BEGINTIPS:
               this.onBeginTips(_loc2_);
         }
         if(_loc4_)
         {
            dispatchEvent(_loc4_);
         }
      }
      
      protected function onBeginTips(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         if(StateManager.currentStateType != StateType.FIGHTING)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lanternRiddles.view.beginTipsText",_loc2_));
         }
         var _loc3_:ChatData = new ChatData();
         _loc3_.channel = ChatInputView.GM_NOTICE;
         _loc3_.msg = LanguageMgr.GetTranslation("lanternRiddles.view.beginTipsText",_loc2_);
         ChatManager.Instance.chat(_loc3_);
      }
      
      private function openOrclose(param1:PackageIn) : void
      {
         this._isBegin = param1.readBoolean();
         if(this._isBegin)
         {
            this.smallBugleTips();
            this.showLanternBtn();
         }
         else
         {
            this.deleteLanternBtn();
         }
      }
      
      private function smallBugleTips() : void
      {
         var _loc1_:ChatData = new ChatData();
         _loc1_.type = ChatFormats.CLICK_LANTERN_BEGIN;
         _loc1_.channel = ChatInputView.CROSS_NOTICE;
         _loc1_.msg = LanguageMgr.GetTranslation("hall.view.LanternBegin");
         ChatManager.Instance.chat(_loc1_);
      }
      
      public function showLanternBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LANTERNRIDDLES,true);
      }
      
      public function onLanternShow(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.show();
      }
      
      protected function __onSetLanternTime(param1:LanternEvent) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LANTERNRIDDLES,true,param1.Time);
      }
      
      public function deleteLanternBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LANTERNRIDDLES,false);
      }
      
      public function questionInfo(param1:LanternDataAnalyzer) : void
      {
         this._questionInfo = param1.data;
      }
      
      public function get info() : Object
      {
         return this._questionInfo;
      }
      
      public function show() : void
      {
         if(!this._isBegin)
         {
            ShowTipManager.Instance.showTip(LanguageMgr.GetTranslation("lanternRiddles.view.activityExpired"));
            return;
         }
         if(loadComplete)
         {
            this.showLanternFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LANTERN_RIDDLES);
         }
      }
      
      public function hide() : void
      {
         this.dispose();
      }
      
      private function dispose() : void
      {
         this.removeEvent();
         if(this._lanternView != null)
         {
            this._lanternView.dispose();
            this._lanternView = null;
         }
      }
      
      private function removeEvent() : void
      {
         //DdtActivityIconManager.Instance.removeEventListener(LanternEvent.LANTERN_SETTIME,this.__onSetLanternTime);
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LANTERN_RIDDLES)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.show();
         }
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LANTERN_RIDDLES)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function showLanternFrame() : void
      {
         this._lanternView = ComponentFactory.Instance.creatComponentByStylename("view.LanternRiddlesView");
         this._lanternView.show();
      }
      
      public function checkMoney(param1:int) : Boolean
      {
         if(PlayerManager.Instance.Self.Money < param1)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
      
      public function get isBegin() : Boolean
      {
         return this._isBegin;
      }
   }
}
