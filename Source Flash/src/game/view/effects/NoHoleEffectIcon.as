package game.view.effects
{
   import game.objects.MirariType;
   
   public class NoHoleEffectIcon extends BaseMirariEffectIcon
   {
       
      
      public function NoHoleEffectIcon()
      {
         _iconClass = "asset.game.notDigAsset";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.NoHole;
      }
   }
}
