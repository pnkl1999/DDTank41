package auctionHouse.view
{
   import auctionHouse.event.AuctionHouseEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BaseStripView extends Sprite implements Disposeable
   {
       
      
      protected var _info:AuctionGoodsInfo;
      
      protected var _state:int;
      
      private var _isSelect:Boolean;
      
      private var _cell:AuctionCellViewII;
      
      protected var _name:FilterFrameText;
      
      protected var _count:FilterFrameText;
      
      protected var _leftTime:FilterFrameText;
      
      private var _cleared:Boolean;
      
      private var _rightBG:Bitmap;
      
      protected var stripSelect_bit:Bitmap;
      
      protected var back_mc:Bitmap;
      
      protected var leftBG:Bitmap;
      
      public function BaseStripView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      protected function initView() : void
      {
         this._cleared = false;
         this.back_mc = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.CellBG");
         addChild(this.back_mc);
         this._rightBG = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.StripGoodsLeftBG");
         addChild(this._rightBG);
         this.leftBG = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.StripGoodsRightBG");
         addChild(this.leftBG);
         this._name = ComponentFactory.Instance.creat("auctionHouse.BaseStripName");
         addChild(this._name);
         this._count = ComponentFactory.Instance.creat("auctionHouse.BaseStripCount");
         addChild(this._count);
         this._leftTime = ComponentFactory.Instance.creat("auctionHouse.BaseStripLeftTime");
         addChild(this._leftTime);
         this._name.mouseEnabled = this._count.mouseEnabled = this._leftTime.mouseEnabled = false;
         this._cell = new AuctionCellViewII();
         this._cell.x = this._rightBG.x;
         this._cell.y = this._rightBG.y;
         addChild(this._cell);
         this.stripSelect_bit = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.StripGoodsSelected");
         this.stripSelect_bit.visible = false;
         addChild(this.stripSelect_bit);
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__over);
         addEventListener(MouseEvent.MOUSE_OUT,this.__out);
         addEventListener(MouseEvent.CLICK,this.__click);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__over);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__out);
      }
      
	  internal function get info() : AuctionGoodsInfo
      {
         return this._info;
      }
      
	  internal function set info(param1:AuctionGoodsInfo) : void
      {
         this._info = param1;
         this.update();
         this.updateInfo();
      }
      
	  internal function get isSelect() : Boolean
      {
         return this._isSelect;
      }
      
	  internal function set isSelect(param1:Boolean) : void
      {
         this._isSelect = param1;
         if(this._state != 1)
         {
            this.update();
         }
      }
      
	  internal function clearSelectStrip() : void
      {
         this._cleared = true;
         this.removeEvent();
         this._name.text = "";
         this._count.text = "";
         this._leftTime.text = "";
         if(this._cell)
         {
            ObjectUtils.disposeObject(this._cell);
         }
         mouseEnabled = false;
         buttonMode = false;
         mouseChildren = false;
         this.stripSelect_bit.visible = false;
         this._isSelect = false;
         this._state = 1;
      }
      
      private function update() : void
      {
         if(this._cleared)
         {
            this.initView();
            this.addEvent();
         }
         this.stripSelect_bit.visible = !!this._isSelect ? Boolean(Boolean(true)) : Boolean(Boolean(false));
      }
      
      protected function updateInfo() : void
      {
         this.removeEvent();
         this._cell.info = this._info.BagItemInfo as ItemTemplateInfo;
         this._name.text = this._cell.info.Name;
         this._cell.allowDrag = false;
         this._count.text = this._info.BagItemInfo.Count.toString();
         this._leftTime.text = this._info.getTimeDescription();
         mouseEnabled = true;
         buttonMode = true;
         this.addEvent();
      }
      
      override public function set height(param1:Number) : void
      {
      }
      
      private function __over(param1:MouseEvent) : void
      {
         if(this._isSelect)
         {
            return;
         }
         this.stripSelect_bit.visible = true;
      }
      
      private function __out(param1:MouseEvent) : void
      {
         if(this._isSelect)
         {
            return;
         }
         this.stripSelect_bit.visible = false;
      }
      
      private function __click(param1:MouseEvent) : void
      {
         if(!this._isSelect)
         {
            SoundManager.instance.play("047");
         }
         this.isSelect = true;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
      }
      
      override public function get height() : Number
      {
         return this.stripSelect_bit.height;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         removeEventListener(MouseEvent.CLICK,this.__click);
         if(this._info)
         {
            this._info = null;
         }
         if(this._cell)
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(this.back_mc)
         {
            ObjectUtils.disposeObject(this.back_mc);
         }
         this.back_mc = null;
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(this._count)
         {
            ObjectUtils.disposeObject(this._count);
         }
         this._count = null;
         if(this._leftTime)
         {
            ObjectUtils.disposeObject(this._leftTime);
         }
         this._leftTime = null;
         if(this._rightBG)
         {
            ObjectUtils.disposeObject(this._rightBG);
         }
         this._rightBG = null;
         if(this.stripSelect_bit)
         {
            ObjectUtils.disposeObject(this.stripSelect_bit);
         }
         this.stripSelect_bit = null;
         if(this.leftBG)
         {
            ObjectUtils.disposeObject(this.leftBG);
         }
         this.leftBG = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
