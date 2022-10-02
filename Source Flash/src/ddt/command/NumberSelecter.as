package ddt.command
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class NumberSelecter extends Sprite implements Disposeable
   {
      
      public static const NUMBER_CLOSE:String = "number_close";
      
      public static const NUMBER_ENTER:String = "number_enter";
       
      
      private var _minNum:int;
      
      private var _maxNum:int;
      
      private var _num:int;
      
      private var _reduceBtn:BaseButton;
      
      private var _addBtn:BaseButton;
      
      private var numText:FilterFrameText;
      
      private var _ennable:Boolean = true;
      
      public function NumberSelecter(param1:int = 1, param2:int = 99)
      {
         super();
         this._minNum = param1;
         this._maxNum = param2;
         this.init();
         this.initEvents();
      }
      
      public function get ennable() : Boolean
      {
         return this._ennable;
      }
      
      public function set ennable(param1:Boolean) : void
      {
         this._ennable = param1;
         if(!this._ennable)
         {
            this._reduceBtn.enable = this._addBtn.enable = this._ennable;
            this.numText.mouseEnabled = false;
         }
      }
      
      private function init() : void
      {
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.core.QuickNumberTextBG");
         addChild(_loc1_);
         this._reduceBtn = ComponentFactory.Instance.creatComponentByStylename("core.quickNumberLeftBtn");
         addChild(this._reduceBtn);
         this._addBtn = ComponentFactory.Instance.creatComponentByStylename("core.quickNumberRightBtn");
         addChild(this._addBtn);
         this.numText = ComponentFactory.Instance.creatComponentByStylename("core.quickNumberText");
         addChild(this.numText);
         this._num = 1;
         this.updateView();
      }
      
      private function initEvents() : void
      {
         this._reduceBtn.addEventListener(MouseEvent.CLICK,this.reduceBtnClickHandler);
         this._addBtn.addEventListener(MouseEvent.CLICK,this.addBtnClickHandler);
         this.numText.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this.numText.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.numText.addEventListener(Event.CHANGE,this.changeHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.addtoStageHandler);
      }
      
      private function removeEvents() : void
      {
         this._reduceBtn.removeEventListener(MouseEvent.CLICK,this.reduceBtnClickHandler);
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.addBtnClickHandler);
         this.numText.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this.numText.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.numText.removeEventListener(Event.CHANGE,this.changeHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.addtoStageHandler);
      }
      
      private function addtoStageHandler(param1:Event) : void
      {
         this.setFocus();
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      private function changeHandler(param1:Event) : void
      {
         this.number = int(this.numText.text);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.number = int(this.numText.text);
            dispatchEvent(new Event(NUMBER_ENTER,true));
         }
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            dispatchEvent(new Event(NUMBER_CLOSE));
         }
      }
      
      private function reduceBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.number -= 1;
      }
      
      private function addBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.number += 1;
      }
      
      public function setFocus() : void
      {
         if(stage.focus != this.numText)
         {
            this.numText.text = "";
            this.numText.appendText(String(this._num));
            stage.focus = this.numText;
         }
      }
      
      public function set maximum(param1:int) : void
      {
         this._maxNum = param1;
         this.number = this._num;
      }
      
      public function set minimum(param1:int) : void
      {
         this._minNum = param1;
         this.number = this._num;
      }
      
      public function set number(param1:int) : void
      {
         if(param1 < this._minNum)
         {
            param1 = this._minNum;
         }
         else if(param1 > this._maxNum)
         {
            param1 = this._maxNum;
         }
         this._num = param1;
         this.updateView();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get number() : int
      {
         return this._num;
      }
      
      private function updateView() : void
      {
         this.numText.text = this._num.toString();
         this._reduceBtn.enable = this._num > this._minNum;
         this._addBtn.enable = this._num < this._maxNum;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._reduceBtn)
         {
            ObjectUtils.disposeObject(this._reduceBtn);
         }
         this._reduceBtn = null;
         if(this._addBtn)
         {
            ObjectUtils.disposeObject(this._addBtn);
         }
         this._addBtn = null;
         if(this.numText)
         {
            ObjectUtils.disposeObject(this.numText);
         }
         this.numText = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
