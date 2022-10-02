package bagAndInfo.info
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   
   public class PlayerInfoViewControl
   {
      
      private static var _view:PlayerInfoFrame;
      
      private static var _tempInfo:PlayerInfo;
      
      public static var isOpenFromBag:Boolean;
       
	  public static var currentPlayer:PlayerInfo;
      
      public function PlayerInfoViewControl()
      {
         super();
      }
      
      public static function view(param1:PlayerInfo, param2:Boolean = true) : void
      {
         if(param1)
         {
            if(param1.Style != null)
            {
               if(_view == null)
               {
                  _view = ComponentFactory.Instance.creatComponentByStylename("bag.personelInfoViewFrame");
               }
               _view.info = param1;
               _view.show();
               _view.setAchivEnable(param2);
               _view.addEventListener(FrameEvent.RESPONSE,__responseHandler);
            }
            else
            {
               param1.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__infoChange);
            }
            SocketManager.Instance.out.sendItemEquip(param1.ID);
         }
      }
      
      private static function __infoChange(param1:PlayerPropertyEvent) : void
      {
         if(PlayerInfo(param1.currentTarget).Style)
         {
            PlayerInfo(param1.target).removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__infoChange);
            if(_view == null)
            {
               _view = ComponentFactory.Instance.creatComponentByStylename("bag.personelInfoViewFrame");
            }
            _view.info = PlayerInfo(param1.target);
            _view.show();
            _view.addEventListener(FrameEvent.RESPONSE,__responseHandler);
         }
      }
      
      public static function viewByID(param1:int, param2:int = -1, param3:Boolean = true) : void
      {
         var _loc4_:PlayerInfo = PlayerManager.Instance.findPlayer(param1,param2);
         view(_loc4_,param3);
      }
      
      public static function viewByNickName(param1:String, param2:int = -1, param3:Boolean = true) : void
      {
         _tempInfo = new PlayerInfo();
         _tempInfo = PlayerManager.Instance.findPlayerByNickName(_tempInfo,param1);
         if(_tempInfo.ID)
         {
            view(_tempInfo,param3);
         }
         else
         {
            SocketManager.Instance.out.sendItemEquip(_tempInfo.NickName,true);
            _tempInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__IDChange);
         }
      }
      
      private static function __IDChange(param1:PlayerPropertyEvent) : void
      {
         _tempInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__IDChange);
         view(_tempInfo);
      }
      
      private static function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               _view.dispose();
               clearView();
               if(isOpenFromBag && StateManager.currentStateType != StateType.FIGHTING)
               {
                  BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.GIFTVIEW);
               }
               isOpenFromBag = false;
         }
      }
      
      public static function closeView() : void
      {
         if(_view && _view.parent)
         {
            _view.removeEventListener(FrameEvent.RESPONSE,__responseHandler);
            _view.dispose();
         }
         _view = null;
      }
      
      public static function clearView() : void
      {
         if(_view)
         {
            _view.removeEventListener(FrameEvent.RESPONSE,__responseHandler);
         }
         _view = null;
      }
   }
}
