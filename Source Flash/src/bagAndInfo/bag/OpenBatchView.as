package bagAndInfo.bag
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class OpenBatchView extends BaseAlerFrame
   {
       
      
      private var _item:InventoryItemInfo;
      
      private var _txt:FilterFrameText;
      
      private var _inputBg:Bitmap;
      
      private var _inputText:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      public function OpenBatchView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set item(param1:InventoryItemInfo) : void
      {
         this._item = param1;
      }
      
      private function initView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.bag.item.openBatch.titleStr"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         _loc1_.moveEnable = false;
         _loc1_.autoDispose = false;
         _loc1_.sound = "008";
         info = _loc1_;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("openBatchView.promptTxt");
         this._txt.text = LanguageMgr.GetTranslation("ddt.bag.item.openBatch.promptStr");
         this._inputBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.openBatchView.inputBg");
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("openBatchView.inputTxt");
         this._inputText.text = "1";
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("openBatchView.maxBtn");
         addToContent(this._txt);
         addToContent(this._inputBg);
         addToContent(this._inputText);
         addToContent(this._maxBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHandler,false,0,true);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.changeMaxHandler,false,0,true);
         this._inputText.addEventListener(Event.CHANGE,this.inputTextChangeHandler,false,0,true);
      }
      
      private function changeMaxHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._item)
         {
            this._inputText.text = this._item.Count.toString();
         }
      }
      
      private function inputTextChangeHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this._item)
         {
            _loc2_ = int(this._inputText.text);
            if(_loc2_ > this._item.Count)
            {
               this._inputText.text = this._item.Count.toString();
            }
            if(_loc2_ < 1)
            {
               this._inputText.text = "1";
            }
         }
      }
      
      private function responseHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(this._item)
               {
                  if(this._item.CategoryID != EquipType.CARDBOX)
                  {
                     SocketManager.Instance.out.sendItemOpenUp(this._item.BagType,this._item.Place,int(this._inputText.text));
                  }
               }
               this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.responseHandler);
         this._maxBtn.removeEventListener(MouseEvent.CLICK,this.changeMaxHandler);
         this._inputText.removeEventListener(Event.CHANGE,this.inputTextChangeHandler);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._item = null;
         this._txt = null;
         this._inputBg = null;
         this._inputText = null;
         this._maxBtn = null;
      }
   }
}
