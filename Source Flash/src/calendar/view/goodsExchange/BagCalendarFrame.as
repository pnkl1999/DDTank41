package calendar.view.goodsExchange
{
   import bagAndInfo.bag.BagFrame;
   import bagAndInfo.bag.BagView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   
   public class BagCalendarFrame extends BagFrame
   {
       
      
      public function BagCalendarFrame()
      {
         super();
         escEnable = true;
      }
      
      override protected function initView() : void
      {
         _bagView = ComponentFactory.Instance.creatCustomObject("bagFrameBagView");
         _bagView.info = PlayerManager.Instance.Self;
         _bagView.setBagType(BagView.EQUIP);
         addToContent(_bagView);
      }
      
      override public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false);
         _isShow = true;
      }
      
      override protected function onResponse(param1:int) : void
      {
         SoundManager.instance.play("008");
         switch(param1)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               hide();
         }
      }
   }
}
