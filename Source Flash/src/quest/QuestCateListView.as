package quest
{
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.TaskManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuestCateListView extends ScrollPanel
   {
      
      public static var MAX_LIST_LENGTH:int = 4;
       
      
      private var _content:VBox;
      
      private var _stripArr:Array;
      
      private var _currentStrip:TaskPannelStripView;
      
      public function QuestCateListView()
      {
         super();
         this._stripArr = new Array();
         this.initView();
      }
      
      private function initView() : void
      {
      }
      
      public function set dataProvider(param1:Array) : void
      {
         var _loc4_:TaskPannelStripView = null;
         if(param1.length == 0)
         {
            return;
         }
         this.height = 0;
         this.clear();
         this._content = new VBox();
         var _loc2_:Boolean = false;
         if(param1.length > QuestCateListView.MAX_LIST_LENGTH)
         {
            _loc2_ = true;
         }
         var _loc3_:int = 0;
         while(param1[_loc3_])
         {
            _loc4_ = new TaskPannelStripView(param1[_loc3_]);
            _loc4_.addEventListener(MouseEvent.CLICK,this.__onStripClicked);
            this._content.addChild(_loc4_);
            this._stripArr.push(_loc4_);
            _loc3_++;
         }
         setView(this._content);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function active() : void
      {
         var _loc1_:TaskPannelStripView = null;
         for each(_loc1_ in this._stripArr)
         {
            if(_loc1_.info == TaskManager.selectedQuest)
            {
               this.gotoStrip(_loc1_);
               _loc1_.active();
               return;
            }
         }
         if(this._stripArr[0])
         {
            this.gotoStrip(this._stripArr[0]);
            this._stripArr[0].active();
            return;
         }
      }
      
      private function gotoStrip(param1:TaskPannelStripView) : void
      {
         if(this._currentStrip == param1)
         {
            return;
         }
         if(this._currentStrip)
         {
            this._currentStrip.deactive();
         }
         this._currentStrip = param1;
         TaskManager.jumpToQuest(this._currentStrip.info);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function __onStripClicked(param1:MouseEvent) : void
      {
         this.gotoStrip(param1.target as TaskPannelStripView);
      }
      
      private function clear() : void
      {
         var _loc1_:TaskPannelStripView = null;
         if(this._content)
         {
            ObjectUtils.disposeObject(this._content);
            this._content = null;
         }
         for each(_loc1_ in this._stripArr)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__onStripClicked);
            _loc1_.dispose();
            this._stripArr = new Array();
         }
      }
      
      override public function dispose() : void
      {
         this.clear();
         this._currentStrip.dispose();
         this._currentStrip = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
