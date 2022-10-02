package littleGame.actions
{
   import littleGame.LittleGameManager;
   import littleGame.model.LittleLiving;
   import littleGame.model.Scenario;
   import road7th.comm.PackageIn;
   
   public class AddObjectAction extends LittleAction
   {
       
      
      private var _scene:Scenario;
      
      private var _pkg:PackageIn;
      
      public function AddObjectAction()
      {
         super();
      }
      
      override public function parsePackege(scene:Scenario, pkg:PackageIn = null) : void
      {
         this._scene = scene;
         this._pkg = pkg;
         var id:int = this._pkg.readInt();
         var living:LittleLiving = this._scene.findLiving(id);
         if(living)
         {
            living.act(this);
         }
      }
      
      override public function execute() : void
      {
         var type:String = this._pkg.readUTF();
         LittleGameManager.Instance.addObject(this._scene,type,this._pkg);
         finish();
      }
   }
}
