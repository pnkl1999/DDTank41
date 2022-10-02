package lottery.cell
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import fightLib.view.AwardCell;
   import flash.display.Sprite;
   
   public class LotteryAwardCell extends Sprite implements Disposeable
   {
       
      
      private var _awardCell:AwardCell;
      
      private var _buffCell:LotteryBuffCell;
      
      public function LotteryAwardCell()
      {
         super();
      }
      
      private function initCell() : void
      {
         this._awardCell = new AwardCell();
         addChild(this._awardCell);
         this._buffCell = new LotteryBuffCell();
         addChild(this._buffCell);
      }
      
      public function setTemplateId(param1:int, param2:Object = null) : void
      {
         var _loc3_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1);
         if(this.isBuffTemplateId(param1))
         {
            this._buffCell.info = _loc3_;
         }
      }
      
      private function isBuffTemplateId(param1:int) : Boolean
      {
         return param1 == EquipType.PREVENT_KICK || param1 == EquipType.DOUBLE_GESTE_CARD || param1 == EquipType.DOUBLE_EXP_CARD || param1 == EquipType.FREE_PROP_CARD;
      }
      
      public function dispose() : void
      {
         if(this._awardCell)
         {
            ObjectUtils.disposeObject(this._awardCell);
         }
         this._awardCell = null;
         if(this._buffCell)
         {
            ObjectUtils.disposeObject(this._buffCell);
         }
         this._buffCell = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
