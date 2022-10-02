package game.view.effects
{
   import game.objects.MirariType;
   
   public class WeaknessEffectIcon extends BaseMirariEffectIcon
   {
      
      public static const MIRARI_TYPE:int = 4;
       
      
      public function WeaknessEffectIcon()
      {
         _iconClass = "asset.game.TargetingAsset";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.Weakness;
      }
   }
}
