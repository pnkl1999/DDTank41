package church.view.weddingRoomList
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import quest.QuestDescTextAnalyz;
   
   public class DivorcePromptFrame extends BaseAlerFrame
   {
      
      private static var _instance:DivorcePromptFrame;
       
      
      private var _alertInfo:AlertInfo;
      
      private var _infoText:FilterFrameText;
      
      public var isOpenDivorce:Boolean = false;
      
      public function DivorcePromptFrame()
      {
         super();
         this.initialize();
      }
      
      public static function get Instance() : DivorcePromptFrame
      {
         if(_instance == null)
         {
            _instance = ComponentFactory.Instance.creatComponentByStylename("DivorcePromptFrame");
         }
         return _instance;
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("church.view.weddingRoomList.DivorcePromptFrame.yes"),LanguageMgr.GetTranslation("church.view.weddingRoomList.DivorcePromptFrame.no"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("DivorcePromptFrameText");
         var _loc1_:String = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.frameInfo");
         _loc1_ = _loc1_.replace(/XXXX/g,"<font COLOR=\'#FF0000\'>" + PlayerManager.Instance.Self.SpouseName + "</font>");
         _loc1_ = QuestDescTextAnalyz.start(_loc1_);
         this._infoText.htmlText = _loc1_;
         addToContent(this._infoText);
      }
      
      public function show() : void
      {
         if(PlayerManager.Instance.Self.SpouseName != null && PlayerManager.Instance.Self.SpouseName != "")
         {
            SocketManager.Instance.out.sendMateTime(PlayerManager.Instance.Self.SpouseID);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MATE_ONLINE_TIME,this.__mateTimeA);
            SharedManager.Instance.divorceBoolean = false;
            SharedManager.Instance.save();
         }
      }
      
      private function __mateTimeA(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Date = param1.pkg.readDate();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MATE_ONLINE_TIME,this.__mateTimeA);
         var _loc3_:Date = new Date();
         var _loc4_:int = (_loc3_.valueOf() - _loc2_.valueOf()) / (60 * 60000);
         if(_loc4_ > 720)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            this.dispose();
         }
      }
      
      private function removeView() : void
      {
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.isOpenDivorce = true;
               this.dispose();
               StateManager.setState(StateType.CHURCH_ROOM_LIST);
               ComponentSetting.SEND_USELOG_ID(6);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._infoText)
         {
            ObjectUtils.disposeObject(this._infoText);
         }
         this._infoText = null;
         this.removeEvent();
         this.removeView();
      }
   }
}
