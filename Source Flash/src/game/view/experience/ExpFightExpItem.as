package game.view.experience
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import game.GameManager;
   import room.model.RoomInfo;
   
   public class ExpFightExpItem extends Sprite implements Disposeable
   {
       
      
      protected var _bg:Bitmap;
      
      protected var _titleBitmap:Bitmap;
      
      protected var _itemType:String;
      
      protected var _typeTxts:Vector.<ExpTypeTxt>;
      
      protected var _numTxt:ExpCountingTxt;
      
      protected var _step:int;
      
      protected var _value:Number;
      
      protected var _valueArr:Array;
      
      public function ExpFightExpItem(param1:Array)
      {
         super();
         this._valueArr = param1;
         this.init();
      }
      
      protected function init() : void
      {
         this._itemType = ExpTypeTxt.FIGHTING_EXP;
         PositionUtils.setPos(this,"experience.FightingExpItemPos");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.experience.fightExpItemBg");
         this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.experience.fightExpItemTitle");
      }
      
      public function createView() : void
      {
         var _loc2_:Point = null;
         _loc2_ = null;
         var _loc3_:int = 0;
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("experience.txtStartPos");
         _loc2_ = ComponentFactory.Instance.creatCustomObject("experience.txtOffset");
         PositionUtils.setPos(this._bg,"experience.ItemBgPos");
         this._typeTxts = new Vector.<ExpTypeTxt>();
         addChild(this._bg);
         addChild(this._titleBitmap);
         this._step = 0;
         _loc3_ = 0;
         var _loc4_:int = 0;
         var _loc5_:int = this._itemType == ExpTypeTxt.FIGHTING_EXP ? int(int(4)) : (this._itemType == ExpTypeTxt.ATTATCH_EXP ? int(int(9)) : int(int(6)));
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(this._itemType == ExpTypeTxt.ATTATCH_EXP && (_loc6_ == 1 || _loc6_ == 7) && GameManager.Instance.Current.roomType != RoomInfo.MATCH_ROOM && GameManager.Instance.Current.roomType != RoomInfo.CHALLENGE_ROOM)
            {
               _loc4_++;
            }
            else
            {
               this._typeTxts.push(new ExpTypeTxt(this._itemType,_loc6_,this._valueArr[_loc6_ - _loc4_]));
               if(_loc3_ % 2 == 0 && _loc3_ != 8)
               {
                  this._typeTxts[_loc3_].y = _loc1_.y = _loc1_.y + _loc2_.y;
               }
               else
               {
                  this._typeTxts[_loc3_].y = _loc1_.y;
                  this._typeTxts[_loc3_].x = _loc1_.x + _loc2_.x;
               }
               this._typeTxts[_loc3_].addEventListener(Event.CHANGE,this.__updateText);
               addChild(this._typeTxts[_loc3_]);
               _loc3_++;
            }
            _loc6_++;
         }
         this.createNumTxt();
      }
      
      protected function createNumTxt() : void
      {
         this._numTxt = new ExpCountingTxt("experience.expCountTxt","experience.expTxtFilter_1,experience.expTxtFilter_2");
         this._numTxt.addEventListener(Event.CHANGE,this.__onTextChange);
         addChild(this._numTxt);
      }
      
      private function __updateText(param1:Event = null) : void
      {
         this._numTxt.updateNum(param1.currentTarget.value);
      }
      
      protected function __onTextChange(param1:Event) : void
      {
         this._value = param1.currentTarget.targetValue;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get targetValue() : Number
      {
         return this._numTxt.targetValue;
      }
      
      public function dispose() : void
      {
         if(this._numTxt)
         {
            this._numTxt.removeEventListener(Event.CHANGE,this.__onTextChange);
            this._numTxt.dispose();
            this._numTxt = null;
         }
         var _loc1_:int = this._typeTxts.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._typeTxts[_loc2_].removeEventListener(Event.CHANGE,this.__updateText);
            this._typeTxts[_loc2_].dispose();
            this._typeTxts[_loc2_] = null;
            _loc2_++;
         }
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._titleBitmap)
         {
            ObjectUtils.disposeObject(this._titleBitmap);
            this._titleBitmap = null;
         }
         this._valueArr = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
