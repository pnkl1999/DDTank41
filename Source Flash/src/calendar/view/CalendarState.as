package calendar.view
{
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class CalendarState extends Sprite implements ICalendar
   {
       
      
      private var _calendarGrid:CalendarGrid;
      
      private var _awardBar:SignAwardBar;
      
      private var _model:CalendarModel;
      
      public function CalendarState(param1:CalendarModel)
      {
         super();
         this._model = param1;
         this.configUI();
      }
      
      private function configUI() : void
      {
         this._calendarGrid = ComponentFactory.Instance.creatCustomObject("CalendarGrid",[this._model]);
         addChild(this._calendarGrid);
         this._awardBar = ComponentFactory.Instance.creatCustomObject("SignAwardBar",[this._model]);
         addChild(this._awardBar);
      }
      
      public function setData(param1:* = null) : void
      {
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._calendarGrid);
         this._calendarGrid = null;
         ObjectUtils.disposeObject(this._awardBar);
         this._awardBar = null;
         this._model = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
