package game.actions.SkillActions
{
   import com.pickgliss.effect.BaseEffect;
   import game.GameManager;
   import game.animations.IAnimate;
   import game.model.Living;
   import game.model.Player;
   import game.objects.MirariType;
   import game.view.effects.MirariEffectIconManager;
   import road7th.comm.PackageIn;
   
   public class ResolveHurtAction extends SkillAction
   {
       
      
      private var _pkg:PackageIn;
      
      private var _scr:Living;
      
      public function ResolveHurtAction(param1:IAnimate, param2:Living, param3:PackageIn)
      {
         this._pkg = param3;
         this._scr = param2;
         super(param1);
      }
      
      override protected function finish() : void
      {
         var _loc2_:Player = null;
         var _loc5_:Living = null;
         var _loc1_:int = this._pkg.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc5_ = GameManager.Instance.Current.findLiving(this._pkg.readInt());
            if(_loc5_.isPlayer() && _loc5_.isLiving)
            {
               _loc2_ = Player(_loc5_);
               _loc2_.handleMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
            }
            _loc4_++;
         }
         _loc2_ = Player(this._scr);
         _loc2_.handleMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
         super.finish();
      }
   }
}
