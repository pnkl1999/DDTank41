package littleGame.actions
{
   import littleGame.model.Scenario;
   import road7th.comm.PackageIn;
   
   public class UnInhaleAction extends LittleAction
   {
       
      
      private var _scene:Scenario;
      
      private var _endAction:String;
      
      private var _direction:String;
      
      public function UnInhaleAction()
      {
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function parsePackege(scene:Scenario, pkg:PackageIn = null) : void
      {
         this._scene = scene;
         var id:int = pkg.readInt();
         this._endAction = pkg.readUTF();
         this._direction = pkg.readUTF();
         _living = this._scene.findLiving(id);
         if(_living)
         {
            _living.act(this);
         }
      }
      
      override public function execute() : void
      {
         if(_living)
         {
            _living.doAction(this._endAction);
            _living.direction = this._direction;
            _living.MotionState = 2;
         }
         finish();
      }
      
      public function toString() : String
      {
         return "UnInhale_[" + _living + "]";
      }
   }
}
