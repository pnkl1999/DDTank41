package game.actions
{
   import game.objects.GameLiving;
   
   public class FocusInLivingAction extends BaseAction
   {
       
      
      private var _gameLiving:GameLiving;
      
      public function FocusInLivingAction(param1:GameLiving)
      {
         super();
         this._gameLiving = param1;
      }
      
      override public function execute() : void
      {
         if(this._gameLiving)
         {
            this._gameLiving.needFocus(0,0,{"priority":3});
         }
         _isFinished = true;
         this._gameLiving = null;
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this.execute();
      }
   }
}
