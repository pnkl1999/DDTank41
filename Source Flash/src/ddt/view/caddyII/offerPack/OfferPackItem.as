package ddt.view.caddyII.offerPack
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.geom.Rectangle;
   
   public class OfferPackItem extends BaseButton
   {
      
      public static const HSpace:int = 10;
       
      
      private var _count:int = 0;
      
      private var _countField:FilterFrameText;
      
      private var _info:ItemTemplateInfo;
      
      private var _countStyle:String;
      
      private var _seleceted:Boolean = false;
      
      private var _selecetedBitmap:Bitmap;
      
      private var _iconCell:BagCell;
      
      private var _selectedStyle:String;
      
      public function OfferPackItem()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:Rectangle = null;
         _loc1_ = null;
         super.init();
         this._iconCell = CellFactory.instance.createPersonalInfoCell(-1,null,true) as BagCell;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("ddt.view.caddyII.offerPack.OfferPackItem.cellBounds");
         this._iconCell.x = _loc1_.x;
         this._iconCell.y = _loc1_.y;
         this._iconCell.width = _loc1_.width;
         this._iconCell.height = _loc1_.height;
         addChild(this._iconCell);
         this._selecetedBitmap = ComponentFactory.Instance.creatBitmap("ddt.view.caddy.OfferPack.PackItem.Selected");
         addChild(this._selecetedBitmap);
         mouseChildren = true;
      }
      
      public function set selectedStyle(param1:String) : void
      {
         if(this._selectedStyle == param1)
         {
            return;
         }
         this._selectedStyle = param1;
         var _loc2_:Bitmap = this._selecetedBitmap;
         this._selecetedBitmap = ComponentFactory.Instance.creat(this._selectedStyle);
         addChild(this._selecetedBitmap);
         if(_loc2_ && this._selecetedBitmap != _loc2_)
         {
            removeChild(_loc2_);
         }
      }
      
      public function get selectedStyle() : String
      {
         return this._selectedStyle;
      }
      
      public function set countStyle(param1:String) : void
      {
         if(this._countStyle == param1)
         {
            return;
         }
         this._countStyle = param1;
         var _loc2_:FilterFrameText = this._countField;
         this._countField = ComponentFactory.Instance.creat(this._countStyle);
         addChild(this._countField);
         if(_loc2_ && this._countField != _loc2_)
         {
            removeChild(_loc2_);
         }
      }
      
      public function get countStyle() : String
      {
         return this._countStyle;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
         if(this._countField)
         {
            this._countField.text = String(this._count);
         }
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._info;
      }
      
      public function set info(param1:ItemTemplateInfo) : void
      {
         if(this._info != param1)
         {
            this._info = param1;
            this._iconCell.info = this._info;
            setChildIndex(this._iconCell,numChildren - 1);
            this.count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._info.TemplateID);
         }
      }
      
      public function get selected() : Boolean
      {
         return this._seleceted;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._seleceted != param1)
         {
            this._seleceted = param1;
            if(this._selecetedBitmap)
            {
               this._selecetedBitmap.visible = this._seleceted;
            }
         }
      }
   }
}
