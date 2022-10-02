package equipretrieve.view
{
   import bagAndInfo.bag.BagFrame;
   import ddt.manager.PlayerManager;
   
   public class RetrieveBagFrame extends BagFrame
   {
       
      
      public function RetrieveBagFrame()
      {
         super();
      }
      
      override protected function initView() : void
      {
         _bagView = new RetrieveBagView();
         _bagView.info = PlayerManager.Instance.Self;
         addToContent(_bagView);
      }
   }
}
