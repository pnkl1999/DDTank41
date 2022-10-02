package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.ConsortiaPlayerInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class WeekOfferListItem extends Sprite implements IListCell, Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _rank:FilterFrameText;
      
      private var _name:FilterFrameText;
      
      private var _contribute:FilterFrameText;
      
      private var _playerInfo:ConsortiaPlayerInfo;
      
      public function WeekOfferListItem()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.placardAndEvent.weekOfferItemBG");
         this._rank = ComponentFactory.Instance.creatComponentByStylename("eventItem.rank");
         this._name = ComponentFactory.Instance.creatComponentByStylename("eventItem.name");
         this._contribute = ComponentFactory.Instance.creatComponentByStylename("eventItem.contribute");
         addChild(this._bg);
         addChild(this._rank);
         addChild(this._name);
         addChild(this._contribute);
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
         var _loc4_:int = param3 + 1;
         if(_loc4_ == 1)
         {
            this._rank.text = _loc4_ + "st";
         }
         else if(_loc4_ == 2)
         {
            this._rank.text = _loc4_ + "nd";
         }
         else if(_loc4_ == 3)
         {
            this._rank.text = _loc4_ + "rd";
         }
         else
         {
            this._rank.text = _loc4_ + "th";
         }
      }
      
      public function getCellValue() : *
      {
         return this._playerInfo;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._playerInfo = param1;
         this._name.text = this._playerInfo.NickName;
         this._contribute.text = this._playerInfo.LastWeekRichesOffer.toString();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._rank)
         {
            ObjectUtils.disposeObject(this._rank);
         }
         this._rank = null;
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(this._contribute)
         {
            ObjectUtils.disposeObject(this._contribute);
         }
         this._contribute = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
