package game.actions.SkillActions
{
   import game.GameManager;
   import game.animations.IAnimate;
   import game.model.Living;
   import road7th.comm.PackageIn;
   
   public class RevertAction extends SkillAction
   {
       
      
      private var _pkg:PackageIn;
      
      private var _src:Living;
      
      public function RevertAction(param1:IAnimate, param2:Living, param3:PackageIn)
      {
         this._pkg = param3;
         this._src = param2;
         super(param1);
      }
      
      override protected function finish() : void
      {
         var _loc5_:Living = null;
         var _loc1_:int = this._pkg.readInt();
         var _loc2_:Vector.<Living> = new Vector.<Living>();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_.push(GameManager.Instance.Current.findLiving(this._pkg.readInt()));
            _loc3_++;
         }
         var _loc4_:int = this._pkg.readInt();
         for each(_loc5_ in _loc2_)
         {
            _loc5_.updateBlood(_loc5_.blood + _loc4_,0,_loc4_);
         }
         super.finish();
      }
   }
}
