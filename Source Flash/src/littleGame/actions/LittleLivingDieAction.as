package littleGame.actions
{
   import littleGame.model.LittleLiving;
   import littleGame.model.Scenario;
   import road7th.comm.PackageIn;
   
   public class LittleLivingDieAction extends LittleAction
   {
       
      
      private var _lifeTime:int;
      
      private var _life:int;
      
      private var _scene:Scenario;
      
      public function LittleLivingDieAction(scene:Scenario = null, living:LittleLiving = null, life:int = 6)
      {
         _living = living;
         if(_living)
         {
            _living.dieing = true;
         }
         this._life = life;
         this._scene = scene;
         super();
      }
      
      override public function connect(action:LittleAction) : Boolean
      {
         return true;
      }
      
      override public function parsePackege(scene:Scenario, pkg:PackageIn = null) : void
      {
         this._scene = scene;
         var id:int = pkg.readInt();
         var living:LittleLiving = this._scene.findLiving(id);
         if(living && !living.dieing)
         {
            _living = living;
            _living.stand();
            _living.dieing = true;
            _living.act(this);
         }
      }
      
      override public function prepare() : void
      {
         _living.dieing = true;
         this._life = _living.dieLife;
         _living.doAction("die");
      }
      
      override public function execute() : void
      {
         if(this._lifeTime >= this._life)
         {
            _living.dieing = false;
            this._scene.removeLiving(_living);
            finish();
         }
         ++this._lifeTime;
      }
   }
}
