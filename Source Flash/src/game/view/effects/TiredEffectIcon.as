package game.view.effects
{
   import game.objects.MirariType;
   
   public class TiredEffectIcon extends BaseMirariEffectIcon
   {
       
      
      public function TiredEffectIcon()
      {
         _iconClass = "asset.game.tiredAsset";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.Tired;
      }
   }
}
