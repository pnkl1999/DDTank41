package ddt.view.bossbox
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CellEvent;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class BoxVipTipsInfoCell extends BaseCell
   {
       
      
      protected var _itemName:FilterFrameText;
      
      private var _di:Bitmap;
      
      private var _isSelect:Boolean = false;
      
      private var _sunShinBg:Bitmap;
      
      public function BoxVipTipsInfoCell()
      {
         super(ComponentFactory.Instance.creat("asset.timeBox.goodsCellShow"));
         this.initView();
      }
      
      public function set isSelect(param1:Boolean) : void
      {
         this._isSelect = param1;
         grayFilters = !this._isSelect;
         if(this._isSelect)
         {
            this._sunShinBg = ComponentFactory.Instance.creat("asset.timeBox.GoodsCellShinEnable");
            addChild(this._sunShinBg);
         }
         else if(this._sunShinBg)
         {
            ObjectUtils.disposeObject(this._sunShinBg);
            this._sunShinBg = null;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _picPos = new Point(5,5);
      }
      
      protected function initView() : void
      {
         this._di = ComponentFactory.Instance.creat("asset.timeBox.GoodsCellBG");
         var _loc1_:* = ComponentFactory.Instance.creat("asset.timeBox.GoodsCellShin");
         var _loc2_:* = ComponentFactory.Instance.creat("asset.timeBox.goodsCellShow");
         addChild(this._di);
         addChild(_loc1_);
         addChild(_loc2_);
         this._itemName = ComponentFactory.Instance.creat("BoxVipTips.ItemName");
         addChild(this._itemName);
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,this));
      }
      
      public function set itemName(param1:String) : void
      {
         this._itemName.text = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._itemName)
         {
            ObjectUtils.disposeObject(this._itemName);
         }
         this._itemName = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
