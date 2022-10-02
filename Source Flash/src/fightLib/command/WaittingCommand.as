package fightLib.command
{
   import fightLib.FightLibCommandEvent;
   
   public class WaittingCommand extends BaseFightLibCommand
   {
       
      
      protected var _finishFun:Function;
      
      public function WaittingCommand(param1:Function)
      {
         super();
         this._finishFun = param1;
      }
      
      override public function finish() : void
      {
         if(this._finishFun != null)
         {
            this._finishFun();
         }
         super.finish();
      }
      
      override public function excute() : void
      {
         super.excute();
         dispatchEvent(new FightLibCommandEvent(FightLibCommandEvent.WAIT));
      }
      
      override public function dispose() : void
      {
         this._finishFun = null;
         super.dispose();
      }
   }
}
