package times.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import times.TimesController;
   import times.data.TimesEvent;
   import times.data.TimesPicInfo;
   import times.utils.TimesUtils;
   
   public class TimesContentView extends Sprite implements Disposeable
   {
       
      
      private var _controller:TimesController;
      
      private var _bigPics:TimesPicGroup;
      
      private var _prePageBtn:SimpleBitmapButton;
      
      private var _nextPageBtn:SimpleBitmapButton;
      
      private var _maskShape:Shape;
      
      private var _maxIdx:int;
      
      private var _picType:String;
      
      public function TimesContentView()
      {
         super();
      }
      
      public function init(param1:Vector.<TimesPicInfo>) : void
      {
         this._controller = TimesController.Instance;
         this._maxIdx = param1.length;
         this._maskShape = new Shape();
         this._maskShape.graphics.beginFill(0,0.5);
         this._maskShape.graphics.drawRoundRect(0,0,745,406,15,15);
         this._maskShape.graphics.endFill();
         this._bigPics = new TimesPicGroup(param1);
         this._prePageBtn = ComponentFactory.Instance.creatComponentByStylename("times.PreBtn");
         this._nextPageBtn = ComponentFactory.Instance.creatComponentByStylename("times.NextBtn");
         this._bigPics.mask = this._maskShape;
         TimesUtils.setPos(this._bigPics,"times.ContentBigPicPos");
         TimesUtils.setPos(this._maskShape,"times.maskShapePos");
         addChild(this._bigPics);
         addChild(this._maskShape);
         addChild(this._prePageBtn);
         addChild(this._nextPageBtn);
         this.frame = 0;
         this.initEvent();
      }
      
      public function get maxIdx() : int
      {
         return this._maxIdx;
      }
      
      public function set maxIdx(param1:int) : void
      {
         this._maxIdx = param1;
      }
      
      public function set frame(param1:int) : void
      {
         this._bigPics.currentIdx = param1;
         this.load(param1);
      }
      
      public function get frame() : int
      {
         return this._bigPics.currentIdx;
      }
      
      private function load(param1:int) : void
      {
         this._bigPics.load(param1);
      }
      
      private function initEvent() : void
      {
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
      }
      
      private function __onBtnClick(param1:MouseEvent) : void
      {
         this._controller.dispatchEvent(new TimesEvent(TimesEvent.PLAY_SOUND));
         switch(param1.currentTarget)
         {
            case this._prePageBtn:
               this.goPrePage();
               break;
            case this._nextPageBtn:
               this.goNextPage();
         }
      }
      
      private function goPrePage() : void
      {
         if(this._bigPics.currentIdx > 0)
         {
            --this._bigPics.currentIdx;
            this._controller.tryShowTipDisplay(this._bigPics.currentInfo.category,this._bigPics.currentIdx);
            this._controller.tryShowEgg();
            this._controller.updateGuildViewPoint(this._bigPics.currentInfo.category,this._bigPics.currentIdx);
         }
         else
         {
            this._controller.dispatchEvent(new TimesEvent(TimesEvent.GOTO_PRE_CONTENT));
         }
      }
      
      private function goNextPage() : void
      {
         if(this._bigPics.currentIdx < this._maxIdx - 1)
         {
            ++this._bigPics.currentIdx;
            this._controller.tryShowTipDisplay(this._bigPics.currentInfo.category,this._bigPics.currentIdx);
            this._controller.tryShowEgg();
            this._controller.updateGuildViewPoint(this._bigPics.currentInfo.category,this._bigPics.currentIdx);
         }
         else
         {
            this._controller.dispatchEvent(new TimesEvent(TimesEvent.GOTO_NEXT_CONTENT));
         }
      }
      
      public function dispose() : void
      {
         this._controller = null;
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         ObjectUtils.disposeObject(this._bigPics);
         this._bigPics = null;
         ObjectUtils.disposeObject(this._prePageBtn);
         this._prePageBtn = null;
         ObjectUtils.disposeObject(this._nextPageBtn);
         this._nextPageBtn = null;
         if(this._maskShape)
         {
            if(this._maskShape.parent)
            {
               this._maskShape.parent.removeChild(this._maskShape);
            }
            this._maskShape.graphics.clear();
            this._maskShape = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
