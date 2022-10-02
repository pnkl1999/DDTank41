package lottery.cell
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class SmallCardCell extends Sprite implements ITipedDisplay, Disposeable
   {
      
      public static const BIG:String = "";
      
      public static const SMALL:String = "";
       
      
      private var _cardId:int;
      
      private var _selected:Boolean;
      
      protected var _selectedBg:ScaleBitmapImage;
      
      protected var _pic:ScaleFrameImage;
      
      protected var _tipData:Object;
      
      protected var _tipDirection:String;
      
      protected var _tipGapH:int;
      
      protected var _tipGapV:int;
      
      protected var _tipStyle:String;
      
      private var _enable:Boolean = true;
      
      public function SmallCardCell()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      public function set cardId(param1:int) : void
      {
         if(this._cardId == param1)
         {
            return;
         }
         this._cardId = param1;
         this._pic.setFrame(this._cardId);
         this.tipData = LanguageMgr.GetTranslation("tank.lottery.cradName" + String(this._cardId));
      }
      
      public function get cardId() : int
      {
         return this._cardId;
      }
      
      public function get hasCard() : Boolean
      {
         return this._cardId > 0;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         this._selectedBg.visible = this._selected;
      }
      
      public function set enable(param1:Boolean) : void
      {
         if(this._enable == param1)
         {
            return;
         }
         this._enable = param1;
         if(this._enable && this._pic)
         {
            this._pic.filters = null;
         }
         else
         {
            this._pic.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      protected function initView() : void
      {
         this._pic = ComponentFactory.Instance.creatComponentByStylename("lottery.cardCell.cardPic");
         addChild(this._pic);
         this._pic.setFrame(1);
         this._selectedBg = ComponentFactory.Instance.creatComponentByStylename("lottery.cardCell.selctedBg");
         addChild(this._selectedBg);
         this._selectedBg.visible = false;
         this.updateSize();
         ShowTipManager.Instance.addTip(this);
         this.tipStyle = "ddt.view.tips.OneLineTip";
         this.tipDirctions = "5";
         this.tipGapH = -2;
         this.tipGapV = -2;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
      }
      
      private function __onMouseOver(param1:MouseEvent) : void
      {
         if(this._cardId > 0 && this._enable && this._pic)
         {
            filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
      }
      
      private function __onMouseOut(param1:MouseEvent) : void
      {
         if(this._cardId > 0 && this._enable && this._pic)
         {
            filters = null;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
      }
      
      protected function updateSize() : void
      {
         var _loc1_:Rectangle = null;
         _loc1_ = null;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("lottery.cardCell.picSmallSize");
         this._pic.width = _loc1_.width;
         this._pic.height = _loc1_.height;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("lottery.cardCell.selectedSmallSize");
         this._selectedBg.width = _loc1_.width;
         this._selectedBg.height = _loc1_.height;
         this._selectedBg.x = _loc1_.x;
         this._selectedBg.y = _loc1_.y;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirection;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirection = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this._pic;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
      }
   }
}
