package littleGame.actions
{
   import littleGame.LittleGameManager;
   import littleGame.model.LittleLiving;
   import littleGame.model.Scenario;
   import road7th.comm.PackageIn;
   
   public class RemoveObjectAction extends LittleAction
   {
       
      
      private var _scene:Scenario;
      
      private var _pkg:PackageIn;
      
      public function RemoveObjectAction()
      {
         super();
      }
      
      override public function parsePackege(scene:Scenario, pkg:PackageIn = null) : void
      {
         this._scene = scene;
         this._pkg = pkg;
         var id:int = this._pkg.readInt();
         pkg.readUTF();
         var living:LittleLiving = this._scene.findLiving(id);
         if(living)
         {
            living.act(this);
         }
      }
      
      override public function execute() : void
      {
         LittleGameManager.Instance.removeObject(this._scene,this._pkg);
         finish();
      }
   }
}
