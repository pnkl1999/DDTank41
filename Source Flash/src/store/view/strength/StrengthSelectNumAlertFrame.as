package store.view.strength
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class StrengthSelectNumAlertFrame extends BaseAlerFrame
   {
       
      
      protected var _alertInfo:AlertInfo;
      
      protected var _txtExplain:Bitmap;
      
      protected var _btn1:BaseButton;
      
      protected var _btn2:BaseButton;
      
      protected var _inputText:FilterFrameText;
      
      protected var _inputBg:Image;
      
      protected var _maxNum:int = 0;
      
      protected var _minNum:int = 1;
      
      protected var _nowNum:int = 1;
      
      protected var _sellFunction:Function;
      
      protected var _notSellFunction:Function;
      
      public var index:int;
      
      private var _goodsinfo:InventoryItemInfo;
      
      public function StrengthSelectNumAlertFrame()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      protected function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("store.strength.autoSplit.inputNumber"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._btn1 = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerBt1");
         this._btn2 = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerBt2");
         this._txtExplain = ComponentFactory.Instance.creatBitmap("asset.ddtstore.strengthNumTxt");
         PositionUtils.setPos(this._txtExplain,"asset.ddtstore.strengthNumTxtPos");
         this._inputBg = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerInputTextBG");
         this._inputText = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerInputText");
         this._inputText.restrict = "0-9";
         addToContent(this._txtExplain);
         addToContent(this._inputBg);
         addToContent(this._btn1);
         addToContent(this._btn2);
         addToContent(this._inputText);
      }
      
      public function addExeFunction(param1:Function, param2:Function) : void
      {
         this._sellFunction = param1;
         this._notSellFunction = param2;
      }
      
      public function show(param1:int = 5, param2:int = 1) : void
      {
         this._maxNum = param1;
         this._minNum = param2;
         this._nowNum = this._maxNum;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function upSee() : void
      {
         this._inputText.text = this._nowNum.toString();
         this._upbtView();
      }
      
      private function removeView() : void
      {
         if(this._alertInfo)
         {
            this._alertInfo = null;
         }
         if(this._txtExplain)
         {
            ObjectUtils.disposeObject(this._txtExplain);
         }
         this._txtExplain = null;
         if(this._inputBg)
         {
            ObjectUtils.disposeObject(this._inputBg);
         }
         this._inputBg = null;
         if(this._btn1)
         {
            ObjectUtils.disposeObject(this._btn1);
         }
         this._btn1 = null;
         if(this._btn2)
         {
            ObjectUtils.disposeObject(this._btn2);
         }
         this._btn2 = null;
         if(this._inputText)
         {
            ObjectUtils.disposeObject(this._inputText);
         }
         this._inputText = null;
      }
      
      private function setEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._inputText.addEventListener(Event.CHANGE,this._changeInput);
         this._inputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__enterHanlder);
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._btn1.addEventListener(MouseEvent.CLICK,this.click_btn1);
         this._btn2.addEventListener(MouseEvent.CLICK,this.click_btn2);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         if(this._inputText)
         {
            this._inputText.removeEventListener(Event.CHANGE,this._changeInput);
         }
         if(this._inputText)
         {
            this._inputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__enterHanlder);
         }
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         if(this._btn1)
         {
            this._btn1.removeEventListener(MouseEvent.CLICK,this.click_btn1);
         }
         if(this._btn2)
         {
            this._btn2.removeEventListener(MouseEvent.CLICK,this.click_btn2);
         }
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._inputText.appendText(this._nowNum.toString());
         this._inputText.setFocus();
         this._upbtView();
      }
      
      private function _changeInput(param1:Event) : void
      {
         if(int(this._inputText.text) == 0)
         {
            this._nowNum = 1;
         }
         else if(int(this._inputText.text) > this._maxNum)
         {
            this._nowNum = this._maxNum;
         }
         else
         {
            this._nowNum = int(this._inputText.text);
         }
         this.upSee();
      }
      
      private function __enterHanlder(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.__confirm();
         }
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function click_btn1(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._nowNum += 1;
         this.upSee();
      }
      
      private function click_btn2(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._nowNum -= 1;
         this.upSee();
      }
      
      private function _upbtView() : void
      {
         this._btn1.enable = true;
         this._btn2.enable = true;
         if(this._nowNum == this._minNum)
         {
            this._btn2.enable = false;
         }
         else if(this._nowNum == this._maxNum)
         {
            this._btn1.enable = false;
         }
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._notSellFunction != null)
               {
                  this._notSellFunction.call(this);
               }
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.__confirm();
         }
      }
      
      private function __confirm() : void
      {
         if(int(this._inputText.text) >= this._maxNum)
         {
            this._nowNum = this._maxNum;
         }
         else if(int(this._inputText.text) == 0)
         {
            this._nowNum = 1;
         }
         if(this._sellFunction != null)
         {
            this._sellFunction.call(this,this._nowNum,this.goodsinfo,this.index);
         }
      }
      
      public function get goodsinfo() : InventoryItemInfo
      {
         return this._goodsinfo;
      }
      
      public function set goodsinfo(param1:InventoryItemInfo) : void
      {
         this._goodsinfo = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
         if(this._sellFunction != null)
         {
            this._sellFunction = null;
         }
         if(this._notSellFunction != null)
         {
            this._notSellFunction = null;
         }
         if(this.parent)
         {
            removeChild(this);
         }
      }
   }
}
