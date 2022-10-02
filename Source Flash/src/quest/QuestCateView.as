package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestCategory;
   import ddt.events.TaskEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuestCateView extends Sprite implements Disposeable
   {
      
      public static var TITLECLICKED:String = "titleClicked";
      
      public static var EXPANDED:String = "expanded";
      
      public static var COLLAPSED:String = "collapsed";
      
      public static const ENABLE_CHANGE:String = "enableChange";
       
      
      private const ITEM_HEIGHT:int = 38;
      
      private const LIST_SPACE:int = 2;
      
      private const LIST_PADDING:int = 10;
      
      private var _data:QuestCategory;
      
      private var _titleView:QuestCateTitleView;
      
      private var _listView:ScrollPanel;
      
      private var _itemList:VBox;
      
      private var _itemArr:Array;
      
      private var _isExpanded:Boolean;
      
      public var questType:int;
      
      public function QuestCateView(param1:int = -1)
      {
         super();
         this._itemArr = new Array();
         this.questType = param1;
         this.initView();
         this.initEvent();
         this.collapse();
      }
      
      public function get contentHeight() : int
      {
         var _loc1_:int = this._titleView.height;
         if(!this._isExpanded)
         {
            return _loc1_;
         }
         if(this._data.list.length <= QuestCateListView.MAX_LIST_LENGTH)
         {
            return _loc1_ + this._data.list.length * this.ITEM_HEIGHT;
         }
         return _loc1_ + this._listView.height;
      }
      
      public function get length() : int
      {
         if(this.data && this.data.list)
         {
            return this.data.list.length;
         }
         return 0;
      }
      
      public function get data() : QuestCategory
      {
         return this._data;
      }
      
      private function initView() : void
      {
         this._titleView = new QuestCateTitleView(this.questType);
         this._titleView.x = 0;
         this._titleView.y = 0;
         addChild(this._titleView);
         this._itemList = new VBox();
         this._itemList.spacing = this.LIST_SPACE;
         this._listView = ComponentFactory.Instance.creat("core.quest.QuestItemList");
         this._listView.setView(this._itemList);
         this._listView.vScrollProxy = ScrollPanel.AUTO;
         this._listView.hScrollProxy = ScrollPanel.OFF;
         addChild(this._listView);
         this.updateData();
      }
      
      public function set taskStyle(param1:int) : void
      {
         this._titleView.taskStyle = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._itemArr.length)
         {
            (this._itemArr[_loc2_] as TaskPannelStripView).taskStyle = param1;
            _loc2_++;
         }
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
      }
      
      private function initEvent() : void
      {
         this._titleView.addEventListener(MouseEvent.CLICK,this.__onTitleClicked);
         this._listView.addEventListener(Event.CHANGE,this.__onListChange);
         TaskManager.addEventListener(TaskEvent.CHANGED,this.__onQuestData);
      }
      
      private function removeEvent() : void
      {
         this._titleView.removeEventListener(MouseEvent.CLICK,this.__onTitleClicked);
         this._listView.removeEventListener(Event.CHANGE,this.__onListChange);
         TaskManager.removeEventListener(TaskEvent.CHANGED,this.__onQuestData);
      }
      
      public function initData() : void
      {
         this.updateData();
      }
      
      public function active() : Boolean
      {
         if(this._data.list.length == 0)
         {
            return false;
         }
         TaskManager.currentCategory = this.questType;
         this.expand();
         this.updateView();
         dispatchEvent(new Event(TITLECLICKED));
         return true;
      }
      
      private function __onQuestData(param1:TaskEvent) : void
      {
         if(!TaskManager.MainFrame)
         {
            return;
         }
         this.updateData();
         if(this.isExpanded)
         {
            dispatchEvent(new Event(TITLECLICKED));
         }
      }
      
      private function __onTitleClicked(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         TaskManager.MainFrame.currentNewCateView = null;
         if(!this._isExpanded)
         {
            this.active();
         }
      }
      
      private function __onListChange(param1:Event) : void
      {
         this.updateView();
      }
      
      public function set dataProvider(param1:Array) : void
      {
      }
      
      private function updateView() : void
      {
         this.updateTitleView();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get isExpanded() : Boolean
      {
         return this._isExpanded;
      }
      
      public function collapse() : void
      {
         if(this._isExpanded == false)
         {
            return;
         }
         this._isExpanded = false;
         this._titleView.isExpanded = this._isExpanded;
         this._listView.visible = false;
         if(this._listView.parent == this)
         {
            removeChild(this._listView);
         }
         this.updateTitleView();
         dispatchEvent(new Event(COLLAPSED));
      }
      
      public function expand() : void
      {
         var item:TaskPannelStripView = null;
         var hasActive:Boolean = false;
         var i:TaskPannelStripView = null;
         var strip:TaskPannelStripView = null;
         this._isExpanded = true;
         this.updateData();
         this._titleView.isExpanded = this._isExpanded;
         this._listView.visible = true;
         addChild(this._listView);
         for each(item in this._itemArr)
         {
            item.onShow();
         }
         this.updateTitleView();
         hasActive = false;
         for each(i in this._itemArr)
         {
            if(i.info == TaskManager.currentNewQuest)
            {
               i.active();
               hasActive = true;
               break;
            }
         }
         if(!hasActive)
         {
            strip = this._itemList.getChildAt(0) as TaskPannelStripView;
            strip.active();
         }
      }
      
      private function set enable(param1:Boolean) : void
      {
         if(param1)
         {
            this._titleView.enable = true;
         }
         else
         {
            this._titleView.haveNoTag();
            this._titleView.enable = false;
            this.collapse();
         }
         if(visible != param1)
         {
            visible = param1;
            dispatchEvent(new Event(ENABLE_CHANGE));
         }
      }
      
      private function updateData() : void
      {
         var _loc1_:TaskPannelStripView = null;
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         var _loc5_:TaskPannelStripView = null;
         this._data = TaskManager.getAvailableQuests(this.questType);
         if(this._data.list.length == 0 || this.questType == 4 && PlayerManager.Instance.Self.Grade < 3)
         {
            this.enable = false;
            return;
         }
         this.enable = true;
         this.updateTitleView();
         if(!this.isExpanded)
         {
            return;
         }
         if(this._data.list.length > QuestCateListView.MAX_LIST_LENGTH)
         {
            _loc4_ = true;
         }
         for each(_loc1_ in this._itemArr)
         {
            _loc1_.dispose();
         }
         this._itemList.disposeAllChildren();
         this._itemArr = new Array();
         _loc2_ = false;
         _loc3_ = 0;
         while(_loc3_ < this._data.list.length)
         {
            _loc5_ = new TaskPannelStripView(this._data.list[_loc3_]);
            _loc5_.addEventListener(TaskEvent.CHANGED,this.__onItemActived);
            if(_loc4_)
            {
               _loc5_.x = 3;
            }
            else
            {
               _loc5_.x = this.LIST_PADDING;
            }
            if(_loc5_.info == TaskManager.selectedQuest)
            {
               _loc5_.active();
               _loc2_ = true;
            }
            this._itemArr.push(_loc5_);
            this._itemList.addChild(_loc5_);
            _loc3_++;
         }
         if(!_loc2_)
         {
            (this._itemArr[0] as TaskPannelStripView).active();
         }
         this._listView.invalidateViewport();
      }
      
      private function __onItemActived(param1:TaskEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._itemList.numChildren)
         {
            if((this._itemList.getChildAt(_loc2_) as TaskPannelStripView).info != param1.info)
            {
               (this._itemList.getChildAt(_loc2_) as TaskPannelStripView).status = "normal";
            }
            (this._itemList.getChildAt(_loc2_) as TaskPannelStripView).update();
            _loc2_++;
         }
      }
      
      private function updateTitleView() : void
      {
         if(this._isExpanded)
         {
            this._titleView.haveNoTag();
            return;
         }
         if(this._data.haveCompleted)
         {
            this._titleView.haveCompleted();
         }
         else if(this._data.haveRecommend)
         {
            this._titleView.haveRecommond();
         }
         else if(this._data.haveNew)
         {
            this._titleView.haveNew();
         }
         else
         {
            this._titleView.haveNoTag();
         }
         if(this._isExpanded)
         {
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:TaskPannelStripView = null;
         this.removeEvent();
         this._data = null;
         if(this._titleView)
         {
            ObjectUtils.disposeObject(this._titleView);
         }
         this._titleView = null;
         if(this._itemList)
         {
            this._itemList.disposeAllChildren();
            ObjectUtils.disposeObject(this._itemList);
            this._itemList = null;
         }
         if(this._listView)
         {
            ObjectUtils.disposeObject(this._listView);
         }
         this._listView = null;
         while(_loc1_ = this._itemArr.pop())
         {
            if(_loc1_)
            {
               _loc1_.removeEventListener(TaskEvent.CHANGED,this.__onItemActived);
               _loc1_.dispose();
            }
            _loc1_ = null;
         }
         this._itemArr = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
