package game.view.effects
{
   import game.objects.MirariType;
   
   public class LimitMaxForceEffectIcon extends BaseMirariEffectIcon
   {
       
      
      public var force:int;
      
      public function LimitMaxForceEffectIcon()
      {
         _iconClass = "asset.game.limitForceAsset";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.LimitMaxForce;
      }
      
      override public function get single() : Boolean
      {
         return true;
      }
   }
}
