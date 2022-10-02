package game.view.effects
{
   import game.model.Living;
   import game.objects.MirariType;
   
   public class DisenableFlyEffectIcon extends BaseMirariEffectIcon
   {
       
      
      public function DisenableFlyEffectIcon()
      {
         _iconClass = "asset.game.forbidFlyAsset";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.DisenableFly;
      }
      
      override protected function excuteEffectImp(param1:Living) : void
      {
         param1.isLockFly = true;
         super.excuteEffectImp(param1);
      }
      
      override public function unExcuteEffect(param1:Living) : void
      {
         param1.isLockFly = false;
      }
   }
}
