package ddt.manager
{
   import com.pickgliss.utils.ClassUtils;
   import flash.display.MovieClip;
   import game.GameManager;
   import game.model.Living;
   import game.model.Player;
   import game.objects.MirariType;
   import game.objects.SkillType;
   import game.view.effects.BaseMirariEffectIcon;
   import game.view.effects.LimitMaxForceEffectIcon;
   import game.view.effects.MirariEffectIconManager;
   import game.view.effects.ReduceStrengthEffect;
   import road7th.comm.PackageIn;
   
   public class SkillManager
   {
       
      
      public function SkillManager()
      {
         super();
      }
      
      public static function solveWeaponSkillMovieName(param1:int) : String
      {
         return solveSkillMovieName(param1);
      }
      
      public static function solveSkillMovieName(param1:int) : String
      {
         return "tank.resource.skill.weapon" + param1;
      }
      
      public static function createWeaponSkillMovieAsset(param1:int) : MovieClip
      {
         return createSkillMovieAsset(param1);
      }
      
      public static function createSkillMovieAsset(param1:int) : MovieClip
      {
         return ClassUtils.CreatInstance(solveSkillMovieName(param1)) as MovieClip;
      }
      
      public static function applySkillToLiving(param1:int, param2:int, ... rest) : void
      {
         switch(param1)
         {
            case SkillType.ForbidFly:
               applyForbidFly(param2);
               break;
            case SkillType.ReduceDander:
               applyReduceDander(param2,rest[0]);
               break;
            case SkillType.ChangeTurnTime:
               applyChangeTurnTime(param2,rest[0],rest[1]);
               break;
            case SkillType.LimitMaxForce:
               applyLimitMaxForce(param2,rest[0]);
               break;
            case SkillType.ReduceStrength:
               applyReduceStrength(param2,rest[0]);
               break;
            case SkillType.ResolveHurt:
               applyResolveHurt(param2,rest[0]);
               break;
            case SkillType.Revert:
               applyRevert(param2,rest[0]);
         }
      }
      
      public static function removeSkillFromLiving(param1:int, param2:int, ... rest) : void
      {
         switch(param1)
         {
            case SkillType.ResolveHurt:
               removeResolveHurt(param2,rest[0]);
         }
      }
      
      private static function applyReduceStrength(param1:int, param2:int) : void
      {
         var _loc4_:ReduceStrengthEffect = null;
         var _loc3_:Living = GameManager.Instance.Current.findLiving(param1);
         if(_loc3_.isPlayer() && _loc3_.isLiving)
         {
            _loc4_ = MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ReduceStrength) as ReduceStrengthEffect;
            _loc4_.strength = param2;
            if(_loc4_ != null)
            {
            }
         }
      }
      
      private static function applyLimitMaxForce(param1:int, param2:int) : void
      {
         var _loc4_:LimitMaxForceEffectIcon = null;
         var _loc3_:Living = GameManager.Instance.Current.findLiving(param1);
         if(_loc3_.isPlayer() && _loc3_.isLiving)
         {
            _loc4_ = MirariEffectIconManager.getInstance().createEffectIcon(MirariType.LimitMaxForce) as LimitMaxForceEffectIcon;
            _loc4_.force = param2;
            if(_loc4_ != null)
            {
            }
         }
      }
      
      private static function applyChangeTurnTime(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:Player = null;
         var _loc4_:Living = GameManager.Instance.Current.findLiving(param1);
         if(_loc4_.isPlayer() && _loc4_.isLiving)
         {
            _loc5_ = _loc4_ as Player;
         }
      }
      
      private static function applyReduceDander(param1:int, param2:int) : void
      {
         var _loc4_:Player = null;
         var _loc3_:Living = GameManager.Instance.Current.findLiving(param1);
         if(_loc3_.isPlayer() && _loc3_.isLiving)
         {
            _loc4_ = _loc3_ as Player;
            _loc4_.dander = param2;
         }
      }
      
      private static function applyForbidFly(param1:int) : void
      {
         var _loc2_:Living = GameManager.Instance.Current.findLiving(param1);
         var _loc3_:BaseMirariEffectIcon = MirariEffectIconManager.getInstance().createEffectIcon(MirariType.DisenableFly);
         if(_loc3_ != null && _loc2_.isLiving)
         {
         }
      }
      
      private static function applyResolveHurt(param1:int, param2:PackageIn) : void
      {
         var _loc3_:Living = GameManager.Instance.Current.findLiving(param1);
         if(_loc3_.isLiving)
         {
            _loc3_.applySkill(SkillType.ResolveHurt,param2);
         }
      }
      
      private static function removeResolveHurt(param1:int, param2:PackageIn) : void
      {
         var _loc4_:Player = null;
         var _loc3_:Living = GameManager.Instance.Current.findLiving(param1);
         if(_loc3_ && _loc3_.isPlayer() && _loc3_.isLiving)
         {
            _loc4_ = Player(_loc3_);
            _loc4_.removeSkillMovie(2);
            _loc4_.removeMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
         }
         var _loc5_:int = param2.readInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = GameManager.Instance.Current.findLiving(param2.readInt());
            if(_loc3_.isPlayer() && _loc3_.isLiving)
            {
               _loc4_ = Player(_loc3_);
               _loc4_.removeSkillMovie(2);
               _loc4_.removeMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
            }
            _loc6_++;
         }
      }
      
      private static function applyRevert(param1:int, param2:PackageIn) : void
      {
         var _loc3_:Living = GameManager.Instance.Current.findLiving(param1);
         if(_loc3_.isLiving)
         {
            _loc3_.applySkill(SkillType.Revert,param2);
         }
      }
   }
}
