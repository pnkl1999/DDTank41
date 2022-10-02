package game.view.effects
{
   import game.objects.MirariType;
   
   public class TargetingEffectIcon extends BaseMirariEffectIcon
   {
       
      
      public function TargetingEffectIcon()
      {
         _iconClass = "asset.game.TargetingAsset";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.Targeting;
      }
   }
}
