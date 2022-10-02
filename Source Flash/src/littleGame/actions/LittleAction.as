package littleGame.actions
{
   import ddt.ddt_internal;
   import littleGame.model.LittleLiving;
   import littleGame.model.Scenario;
   import road7th.comm.PackageIn;
   
   public class LittleAction
   {
       
      
      protected var _isFinished:Boolean = false;
      
      protected var _isPrepare:Boolean = false;
      
      protected var _type:String;
      
      protected var _living:LittleLiving;
      
      public function LittleAction()
      {
         super();
      }
      
      ddt_internal function initializeLiving(living:LittleLiving) : void
      {
         this._living = living;
      }
      
      public function parsePackege(scene:Scenario, pkg:PackageIn = null) : void
      {
      }
      
      public function connect(action:LittleAction) : Boolean
      {
         return false;
      }
      
      public function canReplace(action:LittleAction) : Boolean
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
         this.finish();
      }
      
      protected function finish() : void
      {
         this._isFinished = true;
         this._living = null;
      }
      
      public function cancel() : void
      {
         this._living = null;
      }
   }
}
