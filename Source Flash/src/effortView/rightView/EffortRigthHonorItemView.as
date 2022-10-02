package effortView.rightView
{
   import ddt.manager.EffortManager;
   
   public class EffortRigthHonorItemView extends EffortRigthItemView
   {
      
      public static const MAX_HEIGHT:int = 110;
      
      public static const MIN_HEIGHT:int = 90;
       
      
      public function EffortRigthHonorItemView()
      {
         super();
      }
      
      override protected function update() : void
      {
         this.initMaxHeight();
         this.updateComponent();
         updateSelectState();
         updateDisplayObjectPos();
      }
      
      override protected function updateComponent() : void
      {
         super.updateComponent();
         honorName();
      }
      
      override protected function initMaxHeight() : void
      {
         if(_info && !_info.CompleteStateInfo && _info.effortRewardArray && _info.CanHide && EffortManager.Instance.isSelf)
         {
            _info.maxHeight = MAX_HEIGHT;
         }
         else if(_info)
         {
            _info.maxHeight = MIN_HEIGHT;
         }
      }
   }
}
