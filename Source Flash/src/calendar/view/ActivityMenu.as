package calendar.view
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ActivityMenu extends Sprite implements Disposeable
   {
       
      
      private var _cells:Vector.<ActivityCell>;
      
      private var _model:CalendarModel;
      
      private var _contentHolder:ActivityContentHolder;
      
      private var _selectedItem:ActivityCell;
      
      public function ActivityMenu(param1:CalendarModel)
      {
         this._cells = new Vector.<ActivityCell>();
         super();
         this._model = param1;
         this.configUI();
      }
      
      private function cleanCells() : void
      {
         var _loc1_:ActivityCell = this._cells.shift();
         while(_loc1_ != null)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__cellClick);
            _loc1_ = this._cells.shift();
         }
      }
      
      public function setActivityDate(param1:Date) : void
      {
         var _loc5_:ActiveEventsInfo = null;
         var _loc6_:ActivityCell = null;
         this.cleanCells();
         var _loc2_:int = this._model.eventActives.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this._model.eventActives[_loc4_];
            if(this.isAfterToday(param1) && _loc5_.IsAdvance && this.isInValidDate(param1,_loc5_) || this.isBeforeToday(param1) && this.isInValidDate(param1,_loc5_))
            {
               _loc6_ = new ActivityCell(_loc5_);
               _loc6_.y = _loc4_ * 44;
               _loc6_.addEventListener(MouseEvent.CLICK,this.__cellClick);
               addChild(_loc6_);
               this._cells.push(_loc6_);
            }
            _loc4_++;
         }
         if(this._cells.length > 0)
         {
            this.setSeletedItem(this._cells[0]);
            this._contentHolder.visible = true;
         }
         else if(param1.time != this._model.today.time)
         {
            this._contentHolder.visible = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.NoneActivity"));
         }
         else
         {
            this._contentHolder.visible = false;
         }
      }
      
      private function isInValidDate(param1:Date, param2:ActiveEventsInfo) : Boolean
      {
         var _loc3_:Date = new Date(param1.fullYear,param1.month,param1.date);
         var _loc4_:Date = new Date(param2.start.fullYear,param2.start.month,param2.start.date);
         var _loc5_:Date = new Date(param2.end.fullYear,param2.end.month,param2.end.date);
         if(_loc3_.time <= _loc5_.time && _loc3_.time >= _loc4_.time)
         {
            return true;
         }
         return false;
      }
      
      private function isBeforeToday(param1:Date) : Boolean
      {
         var _loc2_:Date = new Date(param1.fullYear,param1.month,param1.date);
         return _loc2_ <= TimeManager.Instance.Now();
      }
      
      private function isAfterToday(param1:Date) : Boolean
      {
         var _loc2_:Date = new Date(param1.fullYear,param1.month,param1.date);
         return _loc2_ > TimeManager.Instance.Now();
      }
      
      private function configUI() : void
      {
         this._contentHolder = ComponentFactory.Instance.creatCustomObject("ActivityContentHolder");
      }
      
      public function setSeletedItem(param1:ActivityCell) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 != this._selectedItem)
         {
            if(this._selectedItem)
            {
               this._selectedItem.selected = false;
            }
            this._selectedItem = param1;
            this._selectedItem.selected = true;
            this._contentHolder.setContent(this._selectedItem.info);
            addChildAt(this._contentHolder,0);
            _loc2_ = this._cells.indexOf(this._selectedItem);
            _loc3_ = this._cells.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(_loc4_ <= _loc2_)
               {
                  this._cells[_loc4_].y = _loc4_ * 44;
               }
               else
               {
                  this._cells[_loc4_].y = _loc4_ * 44 + this._contentHolder.height - 10;
               }
               _loc4_++;
            }
            this._contentHolder.y = this._selectedItem.y + 32;
         }
      }
      
      private function __cellClick(param1:MouseEvent) : void
      {
         var _loc2_:ActivityCell = param1.currentTarget as ActivityCell;
         this.setSeletedItem(_loc2_);
         CalendarManager.getInstance().setState(CalendarModel.Activity,_loc2_.info);
         SoundManager.instance.play("008");
      }
      
      override public function get height() : Number
      {
         var _loc1_:int = 0;
         if(this._cells.length == 1)
         {
            _loc1_ = this._contentHolder.y + this._contentHolder.height;
         }
         else if(this._cells.length > 0)
         {
            _loc1_ = 44 * this._cells.length + this._contentHolder.height - 8;
         }
         return _loc1_;
      }
      
      public function showByQQ(param1:int) : void
      {
         var _loc2_:ActivityCell = null;
         for each(_loc2_ in this._cells)
         {
            if(_loc2_.info.ActiveID == param1)
            {
               _loc2_.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               _loc2_.openCell();
               this._contentHolder.visible = true;
               break;
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:ActivityCell = this._cells.shift();
         while(_loc1_ != null)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__cellClick);
            _loc1_ = this._cells.shift();
         }
         ObjectUtils.disposeObject(this._contentHolder);
         this._contentHolder = null;
         this._selectedItem = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
