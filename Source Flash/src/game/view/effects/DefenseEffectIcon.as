package game.view.effects
{
   import game.objects.MirariType;
   
   public class DefenseEffectIcon extends BaseMirariEffectIcon
   {
       
      
      public function DefenseEffectIcon()
      {
         _iconClass = "asset.game.buff.defense";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.Defense;
      }
   }
}
