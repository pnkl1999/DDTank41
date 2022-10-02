package store.view.shortcutBuy
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ShortcutBuyFrame extends Frame
   {
      
      public static const ADDFrameHeight:int = 60;
      
      public static const ADD_OKBTN_Y:int = 43;
       
      
      private var _view:ShortCutBuyView;
      
      private var _panelIndex:int;
      
      private var _showRadioBtn:Boolean;
      
      private var okBtn:TextButton;
      
      public function ShortcutBuyFrame()
      {
         super();
      }
      
      public function show(param1:Array, param2:Boolean, param3:String, param4:int) : void
      {
         this.titleText = param3;
         this._showRadioBtn = param2;
         this._panelIndex = param4;
         this._view = new ShortCutBuyView(param1,param2);
         escEnable = true;
         enterEnable = true;
         this.initII();
         this.initEvents();
         this.showToLayer();
      }
      
      private function initII() : void
      {
         this._view.addEventListener(Event.CHANGE,this.changeHandler);
         this._view.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         addToContent(this._view);
         if(!this._showRadioBtn)
         {
            this._view.x += 5;
         }
         this.okBtn = ComponentFactory.Instance.creatComponentByStylename("store.ShortBuyFrameEnter");
         this.okBtn.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         height = this._view.height + this._containerY + ADDFrameHeight;
         this.okBtn.y = height - ADD_OKBTN_Y;
         addChild(this.okBtn);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this.okBtn.addEventListener(MouseEvent.CLICK,this.okFun);
         addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this.okBtn.removeEventListener(MouseEvent.CLICK,this.okFun);
         removeEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function _numberClose(param1:Event) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function _numberEnter(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         this.okFun(null);
      }
      
      private function changeHandler(param1:Event) : void
      {
         this.okBtn.enable = this._view.totalGift != 0 || this._view.totalMoney != 0;
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            ObjectUtils.disposeObject(this);
         }
         else if(param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.okFun(null);
         }
      }
      
      private function okFun(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._view.currentShopItem == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellView.Choose"));
            this._view.List.shine();
            return;
         }
         if(this._view.totalMoney > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
            ObjectUtils.disposeObject(this);
         }
         else if(this._view.totalGift > PlayerManager.Instance.Self.Gift)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.giftLack"));
         }
         else
         {
            this.buyGoods();
            this._view.save();
            this.dispose();
         }
      }
      
      private function buyGoods() : void
      {
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:int = this._view.currentShopItem.GoodsID;
         var _loc8_:int = this._view.totalNum;
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc1_.push(_loc7_);
            _loc2_.push(1);
            _loc3_.push("");
            _loc4_.push(false);
            _loc5_.push("");
            _loc6_.push(-1);
            _loc9_++;
         }
         SocketManager.Instance.out.sendBuyGoods(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,this._panelIndex);
      }
      
      private function showToLayer() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         this._view.removeEventListener(Event.CHANGE,this.changeHandler);
         this._view.dispose();
         super.dispose();
         this._view = null;
         if(this.okBtn)
         {
            ObjectUtils.disposeObject(this.okBtn);
         }
         this.okBtn = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
