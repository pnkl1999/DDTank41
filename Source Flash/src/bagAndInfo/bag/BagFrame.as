package bagAndInfo.bag
{
   import auctionHouse.view.AuctionBagView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   
   public class BagFrame extends Frame
   {
       
      
      protected var _bagView:BagView;
      
      protected var _isShow:Boolean;
      
      protected var _emailBagView:AuctionBagView;
      
      public function BagFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      protected function initView() : void
      {
         this._bagView = ComponentFactory.Instance.creatCustomObject("bagFrameBagView");
         this._bagView.info = PlayerManager.Instance.Self;
         this._emailBagView = ComponentFactory.Instance.creatCustomObject("email.view.EmailBagView.Frame");
         this._emailBagView.info = PlayerManager.Instance.Self;
         addToContent(this._bagView);
      }
      
      public function graySortBtn() : void
      {
         this._bagView.sortBagEnable = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      public function get bagView() : BagView
      {
         return this._bagView;
      }
      
      public function get emailBagView() : AuctionBagView
      {
         return this._emailBagView;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false);
         this._isShow = true;
      }
      
      public function hide() : void
      {
         if(parent)
         {
            parent.removeChild(this);
            this._isShow = false;
         }
      }
      
      public function get isShow() : Boolean
      {
         return this._isShow;
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(this._bagView)
         {
            this._bagView.dispose();
         }
         if(this._bagView)
         {
            ObjectUtils.disposeObject(this._bagView);
         }
         this._bagView = null;
         if(this._emailBagView)
         {
            this._emailBagView.dispose();
         }
         if(this._emailBagView)
         {
            ObjectUtils.disposeObject(this._emailBagView);
         }
         this._emailBagView = null;
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
