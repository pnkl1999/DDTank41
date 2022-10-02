package auctionHouse.view
{
   import bagAndInfo.bag.BagFrame;
   import com.pickgliss.events.FrameEvent;
   import ddt.events.CellEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   
   public class BagAuctionFrame extends BagFrame
   {
       
      
      public function BagAuctionFrame()
      {
         super();
         escEnable = true;
      }
      
      override protected function initView() : void
      {
         _bagView = new AuctionBagView();
         _bagView.isNeedCard(false);
         _bagView.info = PlayerManager.Instance.Self;
         addToContent(_bagView);
         PositionUtils.setPos(_bagView,"AutionBagView.Pos");
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         super.__onCloseClick(null);
      }
      
      override protected function onResponse(param1:int) : void
      {
         SoundManager.instance.play("008");
         switch(param1)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               hide();
               dispatchEvent(new CellEvent(CellEvent.BAG_CLOSE));
         }
      }
   }
}
