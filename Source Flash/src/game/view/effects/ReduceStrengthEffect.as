package game.view.effects
{
   import game.model.Living;
   import game.objects.MirariType;
   
   public class ReduceStrengthEffect extends BaseMirariEffectIcon
   {
       
      
      public var strength:int;
      
      public function ReduceStrengthEffect()
      {
         _iconClass = "asset.game.tiredAsset";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.ReduceStrength;
      }
      
      override protected function excuteEffectImp(param1:Living) : void
      {
         param1.energy = this.strength;
         super.excuteEffectImp(param1);
      }
   }
}
