package game.actions
{
   import ddt.manager.GameInSocketOut;
   import game.model.LocalPlayer;
   
   public class SelfSkipAction extends BaseAction
   {
       
      
      private var _info:LocalPlayer;
      
      public function SelfSkipAction(param1:LocalPlayer)
      {
         super();
         this._info = param1;
      }
      
      override public function prepare() : void
      {
         GameInSocketOut.sendGameSkipNext(this._info.shootTime);
      }
   }
}
