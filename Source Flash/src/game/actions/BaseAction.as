package game.actions
{
   public class BaseAction
   {
       
      
      protected var _isFinished:Boolean;
      
      protected var _isPrepare:Boolean;
      
      public function BaseAction()
      {
         super();
         this._isFinished = false;
      }
      
      public function connect(param1:BaseAction) : Boolean
      {
         return false;
      }
      
      public function canReplace(param1:BaseAction) : Boolean
      {
         return false;
      }
      
      public function get isFinished() : Boolean
      {
         return this._isFinished;
      }
      
      public function prepare() : void
      {
         if(this._isPrepare)
         {
            return;
         }
         this._isPrepare = true;
      }
      
      public function execute() : void
      {
         this.executeAtOnce();
         this._isFinished = true;
      }
      
      public function executeAtOnce() : void
      {
         this.prepare();
         this._isFinished = true;
      }
      
      public function cancel() : void
      {
      }
   }
}
