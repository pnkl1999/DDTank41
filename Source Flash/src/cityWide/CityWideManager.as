package cityWide
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.action.FrameShowAction;
   import ddt.constants.CacheConsts;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.utils.setInterval;
   import im.IMEvent;
   
   public class CityWideManager
   {
      
      private static var _instance:CityWideManager;
       
      
      private var _cityWideView:CityWideFrame;
      
      private var _playerInfo:PlayerInfo;
      
      private var _canOpenCityWide:Boolean = true;
      
      private const TIMES:int = 300000;
      
      public function CityWideManager()
      {
         super();
      }
      
      public static function get Instance() : CityWideManager
      {
         if(_instance == null)
         {
            _instance = new CityWideManager();
         }
         return _instance;
      }
      
      public function init() : void
      {
         PlayerManager.Instance.addEventListener(CityWideEvent.ONS_PLAYERINFO,this._updateCityWide);
      }
      
      private function _updateCityWide(param1:CityWideEvent) : void
      {
         if(this._canOpenCityWide)
         {
            this._playerInfo = param1.playerInfo;
            this.showView(this._playerInfo);
            this._canOpenCityWide = false;
            setInterval(this.changeBoolean,this.TIMES);
         }
      }
      
      public function toSendOpenCityWide() : void
      {
         SocketManager.Instance.out.sendOns();
      }
      
      private function changeBoolean() : void
      {
         this._canOpenCityWide = true;
      }
      
      public function showView(param1:PlayerInfo) : void
      {
         this._cityWideView = ComponentFactory.Instance.creatComponentByStylename("CityWideFrame");
         this._cityWideView.playerInfo = param1;
         this._cityWideView.addEventListener("submit",this._submitExit);
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new FrameShowAction(this._cityWideView));
         }
         else
         {
            this._cityWideView.show();
         }
      }
      
      private function _submitExit(param1:Event) : void
      {
         var _loc3_:BaseAlerFrame = null;
         this._cityWideView = null;
         var _loc2_:int = 0;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            _loc2_ = PlayerManager.Instance.Self.VIPLevel + 2;
         }
         if(PlayerManager.Instance.friendList.length >= 200 + _loc2_ * 50)
         {
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMController.addFriend",200 + _loc2_ * 50),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc3_.addEventListener(FrameEvent.RESPONSE,this._close);
            return;
         }
         SocketManager.Instance.out.sendAddFriend(this._playerInfo.NickName,0,false,true);
         PlayerManager.Instance.addEventListener(IMEvent.ADDNEW_FRIEND,this._addAlert);
      }
      
      private function _close(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         if(_loc2_)
         {
            _loc2_.removeEventListener(FrameEvent.RESPONSE,this._close);
            _loc2_.dispose();
            _loc2_ = null;
         }
      }
      
      private function _addAlert(param1:IMEvent) : void
      {
         PlayerManager.Instance.removeEventListener(IMEvent.ADDNEW_FRIEND,this._addAlert);
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation(""),LanguageMgr.GetTranslation("tank.view.bagII.baglocked.complete"),LanguageMgr.GetTranslation("tank.view.scenechatII.PrivateChatIIView.privatename"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.info.enableHtml = true;
         var _loc3_:String = LanguageMgr.GetTranslation("cityWideFrame.ONSAlertInfo",this._playerInfo.NickName);
         _loc2_.info.data = _loc3_;
         _loc2_.moveEnable = false;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseII);
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         var _loc2_:int = param1.responseCode;
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         ObjectUtils.disposeObject(param1.currentTarget);
         switch(_loc2_)
         {
            case FrameEvent.CANCEL_CLICK:
               ChatManager.Instance.privateChatTo(this._playerInfo.NickName,this._playerInfo.ID);
               ChatManager.Instance.setFocus();
         }
      }
   }
}
