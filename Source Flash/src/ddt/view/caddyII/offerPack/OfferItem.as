package ddt.view.caddyII.offerPack
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class OfferItem extends Sprite implements IListCell
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _cell:BaseCell;
      
      private var _nameTxt:FilterFrameText;
      
      private var _showBG:Boolean = true;
      
      public function OfferItem()
      {
         super();
         this.initView();
         this.initEvents();
         mouseChildren = false;
      }
      
      private function initView() : void
      {
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("offer.itemCellSize");
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,_loc1_.x,_loc1_.y);
         _loc2_.graphics.endFill();
         this._cell = ComponentFactory.Instance.creatCustomObject("offer.itemCell",[_loc2_,null,false]);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("offer.itemNameTxt");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("offer.comboxItembgB");
         addChild(this._bg);
         addChild(this._cell);
         addChild(this._nameTxt);
         buttonMode = true;
         this._bg.visible = false;
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         if(this._bg)
         {
            this._bg.width = param1;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         if(this._bg)
         {
            this._bg.height = param1;
         }
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this._over);
         addEventListener(MouseEvent.MOUSE_OUT,this._out);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this._over);
         removeEventListener(MouseEvent.MOUSE_OUT,this._out);
      }
      
      private function _over(param1:MouseEvent) : void
      {
         if(this._showBG)
         {
            this._bg.visible = true;
         }
      }
      
      private function _out(param1:MouseEvent) : void
      {
         if(this._showBG)
         {
            this._bg.visible = false;
         }
      }
      
      public function set showBG(param1:Boolean) : void
      {
         this._showBG = param1;
      }
      
      public function get showBG() : Boolean
      {
         return this._showBG;
      }
      
      public function set info(param1:ItemTemplateInfo) : void
      {
         this._cell.info = param1;
         this._nameTxt.text = this._cell.info.Name;
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._cell.info;
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._cell.info;
      }
      
      public function setCellValue(param1:*) : void
      {
         this.info = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._cell)
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(this._nameTxt)
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
