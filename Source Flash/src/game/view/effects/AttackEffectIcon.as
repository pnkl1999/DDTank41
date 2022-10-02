package game.view.effects
{
   import game.objects.MirariType;
   
   public class AttackEffectIcon extends BaseMirariEffectIcon
   {
       
      
      public function AttackEffectIcon()
      {
         _iconClass = "asset.game.buff.attack";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.Attack;
      }
   }
}
