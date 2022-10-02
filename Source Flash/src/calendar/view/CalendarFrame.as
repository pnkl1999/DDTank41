package calendar.view
{
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class CalendarFrame extends Frame
   {
       
      
      private var _model:CalendarModel;
      
      private var _stateback:DisplayObject;
      
      private var _activityback:DisplayObject;
      
      private var _currentState:ICalendar;
      
      private var _state:int;
      
      private var _activityList:ActivityList;
      
      private var _titlebitmap:DisplayObject;
      
      private var _luckyNumBar:LuckyNumBar;
      
      public function CalendarFrame(param1:CalendarModel)
      {
         super();
         this._model = param1;
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._stateback = ComponentFactory.Instance.creatComponentByStylename("Calendar.StateBack");
         addToContent(this._stateback);
         this._activityback = ComponentFactory.Instance.creatComponentByStylename("Calendar.ActivityBack");
         addToContent(this._activityback);
         this._activityList = ComponentFactory.Instance.creatCustomObject("ActivityList",[this._model]);
         addToContent(this._activityList);
         this._luckyNumBar = ComponentFactory.Instance.creatCustomObject("LuckyNumBar",[this._model]);
         if(PathManager.getLuckyNumberEnable())
         {
            addToContent(this._luckyNumBar);
         }
         else
         {
            this._activityList.y = this._stateback.y;
            this._activityList.setBackHeight(this._activityback.height - 45);
         }
         this._titlebitmap = ComponentFactory.Instance.creatBitmap("Calendar.List.Title");
         addToContent(this._titlebitmap);
      }
      
      public function lookActivity(param1:Date) : void
      {
      }
      
      public function get activityList() : ActivityList
      {
         return this._activityList;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               CalendarManager.getInstance().close();
         }
      }
      
      private function __signCountChanged(param1:Event) : void
      {
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      public function setState(param1:int, param2:* = null) : void
      {
         if(this._state != param1)
         {
            this._state = param1;
            ObjectUtils.disposeObject(this._currentState);
            this._currentState = null;
            if(this._state == CalendarModel.Calendar)
            {
               this._currentState = ComponentFactory.Instance.creatCustomObject("CalendarState",[this._model]);
               addToContent(this._currentState as DisplayObject);
            }
            else
            {
               this._currentState = ComponentFactory.Instance.creatCustomObject("ActivityState",[this._model]);
               addToContent(this._currentState as DisplayObject);
            }
         }
         if(this._currentState)
         {
            this._currentState.setData(param2);
         }
      }
      
      public function showByQQ(param1:int) : void
      {
         this._activityList.showByQQ(param1);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._stateback);
         this._stateback = null;
         ObjectUtils.disposeObject(this._activityback);
         this._activityback = null;
         ObjectUtils.disposeObject(this._activityList);
         this._activityList = null;
         ObjectUtils.disposeObject(this._currentState);
         this._currentState = null;
         ObjectUtils.disposeObject(this._titlebitmap);
         this._titlebitmap = null;
         ObjectUtils.disposeObject(this._luckyNumBar);
         this._luckyNumBar = null;
         super.dispose();
      }
   }
}
