package game.actions.newHand
{
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import game.GameManager;
   import game.actions.BaseAction;
   import game.model.GameInfo;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.controller.WeakGuildManager;
   
   public class BaseNewHandFightHelpAction extends BaseAction
   {
       
      
      protected var _gameInfo:GameInfo;
      
      function BaseNewHandFightHelpAction()
      {
         super();
         this._gameInfo = GameManager.Instance.Current;
      }
      
      protected function get isInNewHandRoom() : Boolean
      {
         var _loc1_:RoomInfo = RoomManager.Instance.current;
         if(!this._gameInfo || !_loc1_)
         {
            return false;
         }
         return WeakGuildManager.Instance.switchUserGuide && this._gameInfo.livings.length == 2 && this._gameInfo.IsOneOnOne && (_loc1_.type == RoomInfo.MATCH_ROOM || _loc1_.type == RoomInfo.CHALLENGE_ROOM);
      }
      
      protected function showFightTip(param1:String, param2:Number = 1) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation(param1),0,false,param2);
      }
   }
}
