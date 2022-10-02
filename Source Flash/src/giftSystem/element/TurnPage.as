package giftSystem.element
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TurnPage extends Sprite implements Disposeable
   {
      
      public static const CURRENTPAGE_CHANGE:String = "currentPageChange";
       
      
      private var _BG:Bitmap;
      
      private var _numShow:FilterFrameText;
      
      private var _leftBtn:Sprite;
      
      private var _rightBtn:Sprite;
      
      private var _current:int;
      
      private var _total:int;
      
      public function TurnPage()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set current(param1:int) : void
      {
         if(this._current == param1)
         {
            return;
         }
         this._current = param1;
         this._numShow.text = this._current + "/" + this._total;
         dispatchEvent(new Event(CURRENTPAGE_CHANGE));
      }
      
      public function get current() : int
      {
         return this._current;
      }
      
      public function set total(param1:int) : void
      {
         if(this._total == param1)
         {
            return;
         }
         this._total = param1;
         this._numShow.text = this._current + "/" + this._total;
      }
      
      public function get total() : int
      {
         return this._total;
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("asset.giftShop.turnPage");
         this._numShow = ComponentFactory.Instance.creatComponentByStylename("TurnPage.numShow");
         this._leftBtn = this.drawSprit();
         this._rightBtn = this.drawSprit();
         addChild(this._BG);
         addChild(this._numShow);
         addChild(this._leftBtn);
         addChild(this._rightBtn);
         this._leftBtn.x = this._leftBtn.y = this._rightBtn.y = 2;
         this._rightBtn.x = 90;
      }
      
      private function drawSprit() : Sprite
      {
         var _loc1_:Sprite = null;
         _loc1_ = null;
         _loc1_ = new Sprite();
         _loc1_.graphics.beginFill(0,0);
         _loc1_.graphics.drawRect(0,0,25,25);
         _loc1_.graphics.endFill();
         _loc1_.buttonMode = true;
         return _loc1_;
      }
      
      private function initEvent() : void
      {
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.__leftClick);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.__rightClick);
      }
      
      private function __rightClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._current >= this._total)
         {
            this.current = 1;
         }
         else
         {
            ++this.current;
         }
      }
      
      private function __leftClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._current <= 1)
         {
            this.current = this.total;
         }
         else
         {
            --this.current;
         }
      }
      
      private function removeEvent() : void
      {
         this._leftBtn.removeEventListener(MouseEvent.CLICK,this.__leftClick);
         this._rightBtn.removeEventListener(MouseEvent.CLICK,this.__rightClick);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(this._numShow)
         {
            ObjectUtils.disposeObject(this._numShow);
         }
         this._numShow = null;
         if(this._leftBtn)
         {
            ObjectUtils.disposeObject(this._leftBtn);
         }
         this._leftBtn = null;
         if(this._rightBtn)
         {
            ObjectUtils.disposeObject(this._rightBtn);
         }
         this._rightBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
