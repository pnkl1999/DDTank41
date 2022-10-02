package giftSystem.element
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import giftSystem.data.MyGiftCellInfo;
   import shop.view.ShopItemCell;
   
   public class MyGiftItem extends Sprite implements Disposeable
   {
       
      
      private var _info:MyGiftCellInfo;
      
      private var _BG:Bitmap;
      
      private var _nameBG:Bitmap;
      
      private var _name:FilterFrameText;
      
      private var _ownCount:FilterFrameText;
      
      private var _itemCell:ShopItemCell;
      
      public function MyGiftItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("asset.myGiftItem.BG");
         this._nameBG = ComponentFactory.Instance.creatBitmap("asset.myGiftItem.nameBG");
         this._name = ComponentFactory.Instance.creat("MyGiftItem.name");
         this._ownCount = ComponentFactory.Instance.creat("MyGiftItem.ownCount");
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,59,59);
         _loc1_.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
         this._itemCell.cellSize = 50;
         PositionUtils.setPos(this._itemCell,"MyGiftItem.cellPos");
         addChild(this._BG);
         addChild(this._nameBG);
         addChild(this._name);
         addChild(this._ownCount);
         addChild(this._itemCell);
      }
      
      public function get info() : MyGiftCellInfo
      {
         return this._info;
      }
      
      public function set info(param1:MyGiftCellInfo) : void
      {
         this._info = param1;
         this.upView();
      }
      
      private function upView() : void
      {
         if(this._info == null)
         {
            return;
         }
         var _loc1_:ShopItemInfo = this._info.info;
         if(_loc1_ == null)
         {
            return;
         }
         this._itemCell.info = _loc1_.TemplateInfo;
         this._name.text = this._itemCell.info.Name;
         this._ownCount.htmlText = LanguageMgr.GetTranslation("ddt.giftSystem.MyGiftItem.own",this._info.amount);
      }
      
      public function set ownCount(param1:int) : void
      {
         this._ownCount.htmlText = LanguageMgr.GetTranslation("ddt.giftSystem.MyGiftItem.own",param1);
      }
      
      override public function get height() : Number
      {
         return this._BG.height;
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._info = null;
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(this._nameBG)
         {
            ObjectUtils.disposeObject(this._nameBG);
         }
         this._nameBG = null;
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(this._ownCount)
         {
            ObjectUtils.disposeObject(this._ownCount);
         }
         this._ownCount = null;
         if(this._itemCell)
         {
            ObjectUtils.disposeObject(this._itemCell);
         }
         this._itemCell = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
