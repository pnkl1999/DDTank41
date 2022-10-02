package giftSystem.element
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ChooseNum extends Sprite implements Disposeable
   {
      
      public static const NUMBER_IS_CHANGE:String = "numberIsChange";
       
      
      private var _BG:Bitmap;
      
      private var _leftBtn:Sprite;
      
      private var _rightBtn:Sprite;
      
      private var _numShow:TextInput;
      
      private var _number:int;
      
      public function ChooseNum()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set number(param1:int) : void
      {
         this._number = param1;
         this._numShow.text = this._number.toString();
         dispatchEvent(new Event(NUMBER_IS_CHANGE));
      }
      
      public function get number() : int
      {
         return this._number;
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("asset.GiftCartItem.BG");
         this._leftBtn = this.drawSprit();
         this._rightBtn = this.drawSprit();
         this._numShow = ComponentFactory.Instance.creatComponentByStylename("ChooseNum.numShow");
         this._numShow.textField.restrict = "0-9";
         this._numShow.textField.maxChars = 4;
         addChild(this._BG);
         addChild(this._leftBtn);
         addChild(this._rightBtn);
         addChild(this._numShow);
         this._leftBtn.x = 1;
         this._leftBtn.y = 5;
         this._rightBtn.x = 127;
         this._rightBtn.y = 5;
         this.number = 1;
      }
      
      private function drawSprit() : Sprite
      {
         var _loc1_:Sprite = null;
         _loc1_ = null;
         _loc1_ = new Sprite();
         _loc1_.graphics.beginFill(0,0);
         _loc1_.graphics.drawRect(0,0,28,28);
         _loc1_.graphics.endFill();
         _loc1_.buttonMode = true;
         return _loc1_;
      }
      
      private function initEvent() : void
      {
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.__leftClick);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.__rightClick);
         this._numShow.addEventListener(Event.CHANGE,this.__numberChange);
      }
      
      private function __rightClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.number == 9999)
         {
            return;
         }
         ++this.number;
      }
      
      private function __leftClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.number == 1)
         {
            return;
         }
         --this.number;
      }
      
      private function removeEvent() : void
      {
         this._leftBtn.removeEventListener(MouseEvent.CLICK,this.__leftClick);
         this._rightBtn.removeEventListener(MouseEvent.CLICK,this.__rightClick);
         this._numShow.addEventListener(Event.CHANGE,this.__numberChange);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._BG = null;
         this._leftBtn = null;
         this._rightBtn = null;
         this._numShow = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __numberChange(param1:Event) : void
      {
         if(this._numShow.text == "" || parseInt(this._numShow.text) == 0)
         {
            this.number = 1;
         }
         else
         {
            this.number = parseInt(this._numShow.text);
         }
      }
   }
}
