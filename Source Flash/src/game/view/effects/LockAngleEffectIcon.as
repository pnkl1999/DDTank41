package game.view.effects
{
   import game.model.Living;
   import game.objects.MirariType;
   
   public class LockAngleEffectIcon extends BaseMirariEffectIcon
   {
       
      
      public function LockAngleEffectIcon()
      {
         _iconClass = "asset.game.lockAngelAsset";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.LockAngl;
      }
      
      override protected function excuteEffectImp(param1:Living) : void
      {
         param1.isLockAngle = true;
         super.excuteEffectImp(param1);
      }
      
      override public function unExcuteEffect(param1:Living) : void
      {
         param1.isLockAngle = false;
      }
   }
}
