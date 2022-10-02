package labyrinth.view
{
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import labyrinth.data.RankingInfo;
   
   public class RankingListItem extends Sprite implements Disposeable, IListCell
   {
       
      
      private var _itemBG:ScaleFrameImage;
      
      private var _ranking:FilterFrameText;
      
      private var _name:FilterFrameText;
      
      private var _number:FilterFrameText;
      
      private var _info:RankingInfo;
      
      public function RankingListItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._itemBG = UICreatShortcut.creatAndAdd("labyrinth.RankingListItem.itemBG",this);
         this._ranking = UICreatShortcut.creatTextAndAdd("ddt.labyrinth.RankingListItem.text1","1",this);
         this._name = UICreatShortcut.creatTextAndAdd("ddt.labyrinth.RankingListItem.text2","大胖子",this);
         this._number = UICreatShortcut.creatTextAndAdd("ddt.labyrinth.RankingListItem.text3","23232",this);
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
         if(param3 % 2 != 0)
         {
            this._itemBG.setFrame(2);
         }
         else
         {
            this._itemBG.setFrame(1);
         }
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._info = param1 as RankingInfo;
         this._ranking.text = this._info.PlayerRank.toString();
         this._name.text = this._info.PlayerName.toString();
         this._number.text = this._info.FamLevel.toString();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._itemBG);
         this._itemBG = null;
         ObjectUtils.disposeObject(this._ranking);
         this._ranking = null;
         ObjectUtils.disposeObject(this._name);
         this._name = null;
         ObjectUtils.disposeObject(this._number);
         this._number = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
