package game.view.effects
{
   import game.objects.MirariType;
   
   public class DefendEffectIcon extends BaseMirariEffectIcon
   {
       
      
      public function DefendEffectIcon()
      {
         _iconClass = "asset.game.shieldAsset";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.Defend;
      }
   }
}
