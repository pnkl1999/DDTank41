package room.view.bigMapInfoPanel
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleUpDownImage;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class DropList extends Sprite implements Disposeable
   {
      
      public static const LARGE:String = "large";
      
      public static const SMALL:String = "small";
       
      
      private var _bg:ScaleUpDownImage;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _list:SimpleTileList;
      
      private var _cells:Array;
      
      private var _scrollPanelRect:Rectangle;
      
      public function DropList()
      {
         super();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.room.dropListBg");
         addChild(this._bg);
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("asset.room.dropListPanel");
         this._scrollPanel.vScrollProxy = ScrollPanel.ON;
         this._scrollPanel.hScrollProxy = ScrollPanel.OFF;
         addChild(this._scrollPanel);
         this._scrollPanelRect = ComponentFactory.Instance.creatCustomObject("asset.dropList.scrollPanelRect");
         this._list = new SimpleTileList(5);
         this._list.hSpace = 4;
         this._list.vSpace = 5;
         this._cells = [];
         this._scrollPanel.addEventListener(MouseEvent.ROLL_OVER,this.__overHandler);
         this._scrollPanel.addEventListener(MouseEvent.ROLL_OUT,this.__outHandler);
      }
      
      public function set info(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:BaseCell = null;
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:BaseCell = null;
         while(this._cells.length > 0)
         {
            _loc4_ = this._cells.shift();
            _loc4_.dispose();
         }
         var _loc2_:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.dropList.cellRect");
         for each(_loc3_ in param1)
         {
            _loc5_ = ItemManager.Instance.getTemplateById(_loc3_);
            _loc6_ = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.room.dropCellBgAsset"),_loc5_);
            _loc6_.overBg = ComponentFactory.Instance.creatBitmap("asset.room.dropCellOverBgAsset");
            _loc6_.setContentSize(_loc2_.width,_loc2_.height);
            _loc6_.PicPos = new Point(_loc2_.x,_loc2_.y);
            this._list.addChild(_loc6_);
            this._cells.push(_loc6_);
         }
         this._scrollPanel.setView(this._list);
         this._scrollPanel.height = this._scrollPanelRect.width;
         this._scrollPanel.invalidateViewport();
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         this._bg.height = this._scrollPanelRect.x;
         this._scrollPanel.height = this._scrollPanelRect.height;
         this._scrollPanel.invalidateViewport();
         this._scrollPanel.viewPort.viewPosition = new IntPoint(0,0);
         dispatchEvent(new Event(LARGE));
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
         this._bg.height = this._scrollPanelRect.y;
         this._scrollPanel.height = this._scrollPanelRect.width;
         this._scrollPanel.invalidateViewport();
         this._scrollPanel.viewPort.viewPosition = new IntPoint(0,0);
         dispatchEvent(new Event(SMALL));
      }
      
      public function dispose() : void
      {
         this._scrollPanel.removeEventListener(MouseEvent.ROLL_OVER,this.__overHandler);
         this._scrollPanel.removeEventListener(MouseEvent.ROLL_OUT,this.__outHandler);
         this._list.dispose();
         this._list = null;
         this._scrollPanel.dispose();
         this._scrollPanel = null;
         this._bg.dispose();
         this._bg = null;
         this._cells = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
