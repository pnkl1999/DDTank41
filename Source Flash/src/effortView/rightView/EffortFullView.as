package effortView.rightView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.effort.EffortInfo;
   import ddt.manager.EffortManager;
   import ddt.manager.SoundManager;
   import effortView.EffortController;
   import effortView.leftView.EffortCategoryTitleItem;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   
   public class EffortFullView extends Sprite implements Disposeable
   {
      
      public static const FULL_SIZE:Array = [500,28];
      
      public static const COMMON_SIZE:Array = [240,28];
      
      public static const X_OFFSET:int = 20;
      
      public static const Y_OFFSET:int = 30;
       
      
      private var _recentlyList:VBox;
      
      private var _listArray:Array;
      
      private var _recentlyInfoArray:Array;
      
      private var _scheduleArray:Array;
      
      private var _fullScaleStrip:EffortScaleStrip;
      
      private var _integrationScaleStrip:EffortScaleStrip;
      
      private var _taskScaleStrip:EffortScaleStrip;
      
      private var _roleScaleStrip:EffortScaleStrip;
      
      private var _duplicateScaleStrip:EffortScaleStrip;
      
      private var _combatScaleStrip:EffortScaleStrip;
      
      private var _honorScaleStrip:EffortScaleStrip;
      
      private var fullArray:Array;
      
      private var integrationArray:Array;
      
      private var roleArray:Array;
      
      private var taskArray:Array;
      
      private var duplicateArray:Array;
      
      private var combatArray:Array;
      
      private var honorArray:Array;
      
      private var _controller:EffortController;
      
      private var _itemBg:ScaleBitmapImage;
      
      private var _scaleStripBg:ScaleBitmapImage;
      
      private var _titleText_01:Bitmap;
      
      private var _titleText_02:Bitmap;
      
      public function EffortFullView(param1:EffortController)
      {
         this._controller = param1;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         this._itemBg = ComponentFactory.Instance.creat("effortView.EffortFullView.EffortFullViewBG");
         addChild(this._itemBg);
         this._scaleStripBg = ComponentFactory.Instance.creat("effortView.EffortFullView.EffortFullViewBGII");
         addChild(this._scaleStripBg);
         this._titleText_01 = ComponentFactory.Instance.creat("asset.Effort.title_01");
         addChild(this._titleText_01);
         this._titleText_02 = ComponentFactory.Instance.creat("asset.Effort.title_02");
         addChild(this._titleText_02);
         this.updateItem();
         this.updateScheduleArray();
         this._fullScaleStrip = new EffortScaleStrip(this.fullArray.length,EffortCategoryTitleItem.FULL,FULL_SIZE[0],FULL_SIZE[1]);
         this._fullScaleStrip.setButtonMode(false);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortFullView.ScaleStripPos");
         this._fullScaleStrip.x = _loc1_.x;
         this._fullScaleStrip.y = _loc1_.y;
         addChild(this._fullScaleStrip);
         this._roleScaleStrip = new EffortScaleStrip(this.roleArray.length,EffortCategoryTitleItem.PART,COMMON_SIZE[0],COMMON_SIZE[1]);
         this._roleScaleStrip.x = this._fullScaleStrip.x;
         this._roleScaleStrip.y = this._fullScaleStrip.y + Y_OFFSET;
         this._roleScaleStrip.setButtonMode(true);
         addChild(this._roleScaleStrip);
         this._taskScaleStrip = new EffortScaleStrip(this.taskArray.length,EffortCategoryTitleItem.TASK,COMMON_SIZE[0],COMMON_SIZE[1]);
         this._taskScaleStrip.x = this._roleScaleStrip.x + this._roleScaleStrip.width + X_OFFSET;
         this._taskScaleStrip.y = this._roleScaleStrip.y;
         this._taskScaleStrip.setButtonMode(true);
         addChild(this._taskScaleStrip);
         this._duplicateScaleStrip = new EffortScaleStrip(this.duplicateArray.length,EffortCategoryTitleItem.DUNGEON,COMMON_SIZE[0],COMMON_SIZE[1]);
         this._duplicateScaleStrip.x = this._roleScaleStrip.x;
         this._duplicateScaleStrip.y = this._roleScaleStrip.y + Y_OFFSET;
         this._duplicateScaleStrip.setButtonMode(true);
         addChild(this._duplicateScaleStrip);
         this._combatScaleStrip = new EffortScaleStrip(this.combatArray.length,EffortCategoryTitleItem.FIGHT,COMMON_SIZE[0],COMMON_SIZE[1]);
         this._combatScaleStrip.x = this._duplicateScaleStrip.x + this._duplicateScaleStrip.width + X_OFFSET;
         this._combatScaleStrip.y = this._duplicateScaleStrip.y;
         this._combatScaleStrip.setButtonMode(true);
         addChild(this._combatScaleStrip);
         this._integrationScaleStrip = new EffortScaleStrip(this.integrationArray.length,EffortCategoryTitleItem.INTEGRATION,COMMON_SIZE[0],COMMON_SIZE[1]);
         this._integrationScaleStrip.x = this._duplicateScaleStrip.x;
         this._integrationScaleStrip.y = this._duplicateScaleStrip.y + Y_OFFSET;
         this._integrationScaleStrip.setButtonMode(true);
         addChild(this._integrationScaleStrip);
         this._honorScaleStrip = new EffortScaleStrip(this.integrationArray.length,EffortCategoryTitleItem.HONOR,COMMON_SIZE[0],COMMON_SIZE[1]);
         this._honorScaleStrip.x = this._integrationScaleStrip.x + this._integrationScaleStrip.width + X_OFFSET;
         this._honorScaleStrip.y = this._integrationScaleStrip.y;
         this._honorScaleStrip.setButtonMode(true);
         addChild(this._honorScaleStrip);
         this.updateScaleStrip();
      }
      
      private function initEvent() : void
      {
         this._integrationScaleStrip.addEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._roleScaleStrip.addEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._taskScaleStrip.addEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._duplicateScaleStrip.addEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._combatScaleStrip.addEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._honorScaleStrip.addEventListener(MouseEvent.CLICK,this.__scaleStripClick);
      }
      
      private function updateScheduleArray() : void
      {
         var _loc2_:EffortInfo = null;
         var _loc1_:DictionaryData = EffortManager.Instance.fullList;
         this.fullArray = [];
         this.integrationArray = [];
         this.roleArray = [];
         this.taskArray = [];
         this.duplicateArray = [];
         this.combatArray = [];
         this.honorArray = [];
         this.honorArray = EffortManager.Instance.getHonorEfforts();
         for each(_loc2_ in _loc1_)
         {
            this.fullArray.push(_loc2_);
            switch(_loc2_.PlaceID)
            {
               case 0:
                  this.integrationArray.push(_loc2_);
                  break;
               case 1:
                  this.roleArray.push(_loc2_);
                  break;
               case 2:
                  this.taskArray.push(_loc2_);
                  break;
               case 3:
                  this.duplicateArray.push(_loc2_);
                  break;
               case 4:
                  this.combatArray.push(_loc2_);
                  break;
            }
         }
      }
      
      private function __scaleStripClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._roleScaleStrip:
               this._controller.currentRightViewType = 1;
               break;
            case this._taskScaleStrip:
               this._controller.currentRightViewType = 2;
               break;
            case this._duplicateScaleStrip:
               this._controller.currentRightViewType = 3;
               break;
            case this._combatScaleStrip:
               this._controller.currentRightViewType = 4;
               break;
            case this._integrationScaleStrip:
               this._controller.currentRightViewType = 5;
               break;
            case this._honorScaleStrip:
               this._controller.currentRightViewType = 6;
         }
      }
      
      private function getCurrentSchedule(param1:Array) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         if(EffortManager.Instance.isSelf)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if((param1[_loc3_] as EffortInfo).CompleteStateInfo)
               {
                  _loc2_++;
               }
               _loc3_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               if(EffortManager.Instance.tempEffortIsComplete((param1[_loc4_] as EffortInfo).ID))
               {
                  _loc2_++;
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      private function updateScaleStrip() : void
      {
         this._fullScaleStrip.currentVlaue = this.getCurrentSchedule(this.fullArray);
         this._integrationScaleStrip.currentVlaue = this.getCurrentSchedule(this.integrationArray);
         this._roleScaleStrip.currentVlaue = this.getCurrentSchedule(this.roleArray);
         this._taskScaleStrip.currentVlaue = this.getCurrentSchedule(this.taskArray);
         this._duplicateScaleStrip.currentVlaue = this.getCurrentSchedule(this.duplicateArray);
         this._combatScaleStrip.currentVlaue = this.getCurrentSchedule(this.combatArray);
         this._honorScaleStrip.currentVlaue = this.getCurrentSchedule(this.honorArray);
      }
      
      private function updateItem() : void
      {
         var _loc1_:Point = null;
         var _loc3_:EffortFullItemView = null;
         this.cleanList();
         this._recentlyList = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortFullView.ItemList");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortFullView.ItemListPos");
         this._recentlyList.x = _loc1_.x;
         this._recentlyList.y = _loc1_.y;
         addChild(this._recentlyList);
         if(EffortManager.Instance.isSelf)
         {
            this._recentlyInfoArray = EffortManager.Instance.getNewlyCompleteEffort();
         }
         else
         {
            this._recentlyInfoArray = EffortManager.Instance.getTempNewlyCompleteEffort();
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._recentlyInfoArray.length)
         {
            if(_loc2_ > 3)
            {
               break;
            }
            _loc3_ = new EffortFullItemView(this._recentlyInfoArray[_loc2_]);
            this._recentlyList.addChild(_loc3_);
            _loc2_++;
         }
      }
      
      private function cleanList() : void
      {
         var _loc1_:int = 0;
         if(this._listArray)
         {
            _loc1_ = 0;
            while(_loc1_ < this._listArray.length)
            {
               this._listArray[_loc1_].dispose();
               _loc1_++;
            }
         }
         if(this._recentlyList && this._recentlyList.parent)
         {
            this._recentlyList.parent.removeChild(this._recentlyList);
         }
         this._recentlyList = null;
         this._listArray = [];
      }
      
      public function dispose() : void
      {
         this.cleanList();
         this._integrationScaleStrip.removeEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._roleScaleStrip.removeEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._taskScaleStrip.removeEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._duplicateScaleStrip.removeEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._combatScaleStrip.removeEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         if(this._fullScaleStrip)
         {
            this._fullScaleStrip.parent.removeChild(this._fullScaleStrip);
            this._fullScaleStrip.dispose();
            this._fullScaleStrip = null;
         }
         if(this._integrationScaleStrip)
         {
            this._integrationScaleStrip.parent.removeChild(this._integrationScaleStrip);
            this._integrationScaleStrip.dispose();
            this._integrationScaleStrip = null;
         }
         if(this._roleScaleStrip)
         {
            this._roleScaleStrip.parent.removeChild(this._roleScaleStrip);
            this._roleScaleStrip.dispose();
            this._roleScaleStrip = null;
         }
         if(this._taskScaleStrip)
         {
            this._taskScaleStrip.parent.removeChild(this._taskScaleStrip);
            this._taskScaleStrip.dispose();
            this._taskScaleStrip = null;
         }
         if(this._duplicateScaleStrip)
         {
            this._duplicateScaleStrip.parent.removeChild(this._duplicateScaleStrip);
            this._duplicateScaleStrip.dispose();
            this._duplicateScaleStrip = null;
         }
         if(this._combatScaleStrip)
         {
            this._combatScaleStrip.parent.removeChild(this._combatScaleStrip);
            this._combatScaleStrip.dispose();
            this._combatScaleStrip = null;
         }
         ObjectUtils.disposeAllChildren(this);
         if(this.parent)
         {
            this.removeChild(this);
         }
      }
   }
}
