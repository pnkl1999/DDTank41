package ddt.view.bossbox
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class BoxAwardsCell extends BaseCell implements IListCell
   {
       
      
      protected var _itemName:FilterFrameText;
      
      protected var count_txt:FilterFrameText;
      
      public function BoxAwardsCell()
      {
         super(ComponentFactory.Instance.creat("asset.timeBox.goodsCellShow"));
         this.initII();
         this.addEvent();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _picPos = new Point(5,5);
      }
      
      protected function initII() : void
      {
         var _loc1_:* = ComponentFactory.Instance.creat("asset.timeBox.GoodsCellBG");
         var _loc2_:* = ComponentFactory.Instance.creat("asset.timeBox.GoodsCellShin");
         var _loc3_:* = ComponentFactory.Instance.creat("asset.timeBox.goodsCellShow");
         addChild(_loc1_);
         addChild(_loc2_);
         addChild(_loc3_);
         this._itemName = ComponentFactory.Instance.creat("roulette.GoodsCellName");
         this._itemName.mouseEnabled = false;
         this._itemName.multiline = true;
         this._itemName.wordWrap = true;
         addChild(this._itemName);
         this.count_txt = ComponentFactory.Instance.creat("bossbox.boxCellCount");
         addChild(this.count_txt);
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
      }
      
      public function setCellValue(param1:*) : void
      {
      }
      
      private function addEvent() : void
      {
         addEventListener(Event.CHANGE,this.__setItemName);
      }
      
      public function set count(param1:int) : void
      {
         this.count_txt.parent.removeChild(this.count_txt);
         addChild(this.count_txt);
         if(param1 <= 1)
         {
            this.count_txt.text = "";
            return;
         }
         this.count_txt.text = String(param1);
      }
      
      public function __setItemName(param1:Event) : void
      {
         this.itemName = _info.Name;
      }
      
      public function set itemName(param1:String) : void
      {
         this._itemName.text = param1;
         this._itemName.y = (44 - this._itemName.textHeight) / 2;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(Event.CHANGE,this.__setItemName);
         if(this._itemName)
         {
            ObjectUtils.disposeObject(this._itemName);
         }
         this._itemName = null;
         if(this.count_txt)
         {
            ObjectUtils.disposeObject(this.count_txt);
         }
         this.count_txt = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
