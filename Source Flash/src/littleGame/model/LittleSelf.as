package littleGame.model
{
   import ddt.data.player.SelfInfo;
   import ddt.ddt_internal;
   import littleGame.actions.LittleAction;
   import littleGame.actions.LittleSelfMoveAction;
   import littleGame.data.Node;
   import littleGame.events.LittleLivingEvent;
   
   use namespace ddt_internal;
   
   [Event(name="inhaledChanged",type="littleGame.events.LittleLivingEvent")]
   [Event(name="getscore",type="littleGame.events.LittleLivingEvent")]
   [Event(name="collide",type="littleGame.events.LittleLivingEvent")]
   public class LittleSelf extends LittlePlayer
   {
       
      
      private var _inhaled:Boolean = false;
      
      public function LittleSelf(self:SelfInfo, id:int, x:int, y:int, type:int)
      {
         super(self,id,x,y,type);
      }
      
      override public function stand() : void
      {
         var action:LittleAction = null;
         for each(action in _actionMgr._queue)
         {
            if(action is LittleSelfMoveAction)
            {
               action.cancel();
            }
         }
      }
      
      public function collideByNode(node:Node) : Boolean
      {
         return false;
      }
      
      override public function get isSelf() : Boolean
      {
         return true;
      }
      
      override public function toString() : String
      {
         return "LittleSelf_" + playerInfo.NickName;
      }
      
      public function getScore(score:int) : void
      {
         dispatchEvent(new LittleLivingEvent(LittleLivingEvent.GetScore,score));
      }
      
      public function get inhaled() : Boolean
      {
         return this._inhaled;
      }
      
      public function set inhaled(value:Boolean) : void
      {
         if(this._inhaled == value)
         {
            return;
         }
         this._inhaled = value;
         dispatchEvent(new LittleLivingEvent(LittleLivingEvent.InhaledChanged));
      }
   }
}
