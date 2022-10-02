package game.actions.SkillActions
{
   import game.actions.BaseAction;
   import game.animations.IAnimate;
   
   public class SkillAction extends BaseAction
   {
       
      
      private var _animate:IAnimate;
      
      private var _onComplete:Function;
      
      private var _onCompleteParams:Array;
      
      public function SkillAction(param1:IAnimate, param2:Function = null, param3:Array = null)
      {
         super();
         this._animate = param1;
         this._onComplete = param2;
         this._onCompleteParams = param3;
      }
      
      override public function execute() : void
      {
         if(this._animate != null)
         {
            if(this._animate.finish)
            {
               if(this._onComplete != null)
               {
                  this._onComplete.apply(null,this._onCompleteParams);
               }
               this.finish();
            }
         }
         else
         {
            this.finish();
         }
      }
      
      protected function finish() : void
      {
         _isFinished = true;
      }
   }
}
