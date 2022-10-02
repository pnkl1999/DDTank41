package calendar.view
{
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ActivityList extends Sprite implements Disposeable
   {
       
      
      private var _back:DisplayObject;
      
      private var _list:ScrollPanel;
      
      private var _model:CalendarModel;
      
      private var _activityMenu:ActivityMenu;
      
      public function ActivityList(param1:CalendarModel)
      {
         super();
         this._model = param1;
         this.configUI();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatComponentByStylename("Calendar.ActivityListBack");
         addChild(this._back);
         this._list = ComponentFactory.Instance.creatComponentByStylename("Calendar.ActivityList");
         addChild(this._list);
         this._activityMenu = ComponentFactory.Instance.creatCustomObject("ActivityMenu",[this._model]);
         this._list.setView(this._activityMenu);
      }
      
      public function setActivityDate(param1:Date) : void
      {
         this._activityMenu.setActivityDate(param1);
         this._list.invalidateViewport();
      }
      
      public function showByQQ(param1:int) : void
      {
         this._activityMenu.showByQQ(param1);
      }
      
      public function setBackHeight(param1:int) : void
      {
         this._back.height = param1;
         this._list.height = param1 - 18;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeObject(this._activityMenu);
         this._activityMenu = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
