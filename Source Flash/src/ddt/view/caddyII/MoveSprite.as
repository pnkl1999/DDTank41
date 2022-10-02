package ddt.view.caddyII
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class MoveSprite extends Sprite implements Disposeable
   {
      
      public static const QUEST_CELL_POINT:String = "questCellPoint";
      
      public static const MOVE_COMPLETE:String = "move_complete";
       
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _moveCell:BaseCell;
      
      private var _moveSprite:Sprite;
      
      private var _beginPoint:Point;
      
      private var _src:ItemTemplateInfo;
      
      public function MoveSprite(param1:ItemTemplateInfo)
      {
         super();
         this._src = param1;
         this.initView();
      }
      
      private function initView() : void
      {
         this._moveSprite = CaddyModel.instance.moveSprite;
         addChild(this._moveSprite);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("caddy.selectCellSize");
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,75,75);
         _loc2_.graphics.endFill();
         this._moveCell = ComponentFactory.Instance.creatCustomObject("caddy.moveCell",[_loc2_]);
         this._moveCell.x = this._moveCell.width / 2 * -1;
         this._moveCell.y = this._moveCell.height / 2 * -1;
         this._moveSprite.addChild(this._moveCell);
         this._beginPoint = new Point(this._moveSprite.x,this._moveSprite.y);
         this._moveSprite.visible = false;
      }
      
      public function setInfo(param1:InventoryItemInfo) : void
      {
         this._selectedGoodsInfo = param1;
         this._moveCell.info = param1;
      }
      
      public function startMove() : void
      {
         dispatchEvent(new Event(QUEST_CELL_POINT));
      }
      
      public function setMovePoint(param1:Point) : void
      {
         var _loc2_:Point = globalToLocal(param1);
         this._moveSprite.visible = true;
         if(this._selectedGoodsInfo && this._selectedGoodsInfo.TemplateID == EquipType.BADLUCK_STONE)
         {
            TweenMax.to(this._moveSprite,0.3,{
               "scaleX":2,
               "scaleY":2,
               "repeat":1,
               "yoyo":true
            });
            TweenMax.to(this._moveSprite,0.3,{
               "delay":0.5,
               "x":_loc2_.x + this._moveCell.width / 2 + 7,
               "y":_loc2_.y + this._moveCell.height / 2 + 15,
               "scaleX":0.5,
               "scaleY":0.5,
               "onComplete":this._moveOk
            });
         }
         else if(this._src && this._src.TemplateID == EquipType.Gold_Caddy)
         {
            TweenMax.to(this._moveSprite,0.3,{
               "x":_loc2_.x + this._moveCell.width / 2 + 7,
               "y":_loc2_.y + this._moveCell.height / 2 + 15,
               "onComplete":this._moveOk
            });
         }
         else
         {
            TweenMax.to(this._moveSprite,0.3,{
               "scaleX":2,
               "scaleY":2,
               "repeat":1,
               "yoyo":true
            });
            TweenMax.to(this._moveSprite,0.15,{
               "delay":0.7,
               "x":_loc2_.x + this._moveCell.width / 2 + 7,
               "y":_loc2_.y + this._moveCell.height / 2 + 15,
               "onComplete":this._moveOk
            });
         }
      }
      
      private function _moveOk() : void
      {
         var _loc1_:CaddyEvent = new CaddyEvent(MOVE_COMPLETE);
         _loc1_.info = this._selectedGoodsInfo;
         dispatchEvent(_loc1_);
         if(this._moveSprite)
         {
            this._moveSprite.visible = false;
            this._moveSprite.x = this._beginPoint.x;
            this._moveSprite.y = this._beginPoint.y;
         }
      }
      
      public function dispose() : void
      {
         if(this._moveCell)
         {
            ObjectUtils.disposeObject(this._moveCell);
         }
         this._moveCell = null;
         if(this._moveSprite)
         {
            ObjectUtils.disposeObject(this._moveSprite);
         }
         this._moveSprite = null;
         this._selectedGoodsInfo = null;
         this._beginPoint = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
