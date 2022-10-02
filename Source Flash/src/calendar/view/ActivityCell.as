package calendar.view
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ActivityCell extends Sprite implements Disposeable
   {
       
      
      private var _back:DisplayObject;
      
      private var _icon:DisplayObject;
      
      private var _titleField:FilterFrameText;
      
      private var _info:ActiveEventsInfo;
      
      private var _selected:Boolean = false;
      
      public function ActivityCell(param1:ActiveEventsInfo)
      {
         super();
         this._info = param1;
         buttonMode = true;
         this.configUI();
         this.addEvent();
      }
      
      public function get info() : ActiveEventsInfo
      {
         return this._info;
      }
      
      private function addEvent() : void
      {
      }
      
      private function __detailClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CalendarManager.getInstance().setState(CalendarModel.Activity,this._info);
      }
      
      private function removeEvent() : void
      {
      }
      
      private function configUI() : void
      {
         var _loc1_:int = 0;
         this._back = ComponentFactory.Instance.creatComponentByStylename("Calendar.Activity.CellBack");
         DisplayUtils.setFrame(this._back,!!this._selected ? int(int(2)) : int(int(1)));
         addChild(this._back);
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("Calendar.Activity.CellTitle");
         this._titleField.htmlText = "<b>·</b> " + this._info.Title;
         if(this._titleField.textWidth > 90)
         {
            _loc1_ = this._titleField.getCharIndexAtPoint(this._titleField.x + 86,this._titleField.y + 2);
            this._titleField.htmlText = "<b>·</b> " + this._info.Title.substring(0,_loc1_) + "...";
         }
         addChild(this._titleField);
         if(this._info.Type > 0 && this._info.Type <= 2)
         {
            this._icon = ComponentFactory.Instance.creatComponentByStylename("Calendar.Activity.TitleIcon");
            DisplayUtils.setFrame(this._icon,this._info.Type);
            this._icon.x = this._titleField.x + this._titleField.width + 2;
            addChild(this._icon);
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         DisplayUtils.setFrame(this._back,!!this._selected ? int(int(2)) : int(int(1)));
         DisplayUtils.setFrame(this._titleField,!!this._selected ? int(int(2)) : int(int(1)));
      }
      
      public function openCell() : void
      {
         this.__detailClick(null);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._titleField);
         this._titleField = null;
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
