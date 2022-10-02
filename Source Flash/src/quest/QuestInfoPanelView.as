package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestCondition;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class QuestInfoPanelView extends Sprite
   {
       
      
      private const CONDITION_HEIGHT:int = 32;
      
      private const CONDITION_Y:int = 0;
      
      private const PADDING_Y:int = 8;
      
      private var _BG1:Scale9CornerImage;
      
      private var _BG2:Scale9CornerImage;
      
      private var _info:QuestInfo;
      
      private var _planTitle:Bitmap;
      
      private var _condTitle:Bitmap;
      
      private var descText:FilterFrameText;
      
      private var repeatText:FilterFrameText;
      
      private var necessaryTitle:Bitmap;
      
      private var notNecessaryTitle:Bitmap;
      
      private var condArr:Array;
      
      private var gotoCMoive:MovieClip;
      
      private var container:Sprite;
      
      private var panel:ScrollPanel;
      
      private var _extraFrame:Sprite;
      
      public function QuestInfoPanelView()
      {
         super();
         this.condArr = new Array();
         this.initView();
      }
      
      override public function set height(param1:Number) : void
      {
         this.panel.height = param1 - this._condTitle.height - 4;
         this.panel.invalidateViewport();
         this._BG2.height = this._BG1.height = param1 - 2;
      }
      
      private function initView() : void
      {
         this._BG1 = ComponentFactory.Instance.creatComponentByStylename("asset.quest.targetBGStyle1");
         this._BG2 = ComponentFactory.Instance.creatComponentByStylename("asset.quest.targetBGStyle2");
         this._condTitle = ComponentFactory.Instance.creat("asset.core.quest.QuestInfoCondTitle");
         this.container = new Sprite();
         this.panel = ComponentFactory.Instance.creatComponentByStylename("core.quest.QuestInfoPanel");
         this.panel.setView(this.container);
         this._planTitle = ComponentFactory.Instance.creat("asset.core.quest.QuestInfoPlanTitle");
         this.descText = ComponentFactory.Instance.creat("core.quest.QuestInfoDescription");
         this.descText.mouseEnabled = true;
         this.descText.mouseWheelEnabled = false;
         this.descText.selectable = false;
         this.descText.visible = false;
         this._planTitle.visible = false;
         this.repeatText = ComponentFactory.Instance.creat("core.quest.QuestPlanStatus");
         this.repeatText.visible = false;
         this.notNecessaryTitle = ComponentFactory.Instance.creatBitmap("asset.core.quest.notNecessary");
         this.necessaryTitle = UICreatShortcut.creatAndAdd("asset.core.quest.necessary",this.container);
         this.necessaryTitle.visible = false;
         this.notNecessaryTitle.visible = false;
         addChild(this._BG1);
         addChild(this._BG2);
         addChild(this.panel);
         this.container.addChild(this._planTitle);
         this.container.addChild(this.descText);
         this.container.addChild(this.repeatText);
      }
      
      public function set taskStyle(param1:int) : void
      {
         this._BG1.visible = param1 == TaskMainFrame.NORMAL ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         this._BG2.visible = !this._BG1.visible;
      }
      
      public function set info(param1:QuestInfo) : void
      {
         var _loc5_:QuestConditionView = null;
         var _loc9_:QuestConditionView = null;
         var _loc3_:QuestCondition = null;
         var _loc4_:Array = null;
         _loc5_ = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:QuestCondition = null;
         _loc9_ = null;
         this.clear();
         this._info = param1;
         var _loc2_:int = 0;
         while(this._info._conditions[_loc2_])
         {
            this.necessaryTitle.visible = true;
            this.notNecessaryTitle.visible = false;
            _loc3_ = this._info._conditions[_loc2_];
            _loc4_ = [];
            if(!_loc3_.isOpitional)
            {
               _loc5_ = new QuestConditionView(_loc3_);
               _loc5_.status = this._info.conditionStatus[_loc2_];
               if(this._info.progress[_loc2_] <= 0)
               {
                  _loc5_.isComplete = true;
               }
               _loc5_.x = 0;
               _loc5_.y = _loc2_ * this.CONDITION_HEIGHT + this.CONDITION_Y + this.necessaryTitle.height;
               this.condArr.push(_loc5_);
               this.container.addChild(_loc5_);
            }
            else
            {
               _loc4_.push(_loc3_);
            }
            _loc2_++;
         }
         if(_loc4_.length > 0)
         {
            if(this.condArr.length > 0)
            {
               this.notNecessaryTitle.visible = true;
               this.notNecessaryTitle.y = this.condArr[this.condArr.length - 1].height + this.condArr[this.condArr.length - 1].y;
            }
            else
            {
               this.necessaryTitle.visible = false;
               this.notNecessaryTitle.visible = true;
               this.notNecessaryTitle.y = 0;
            }
            this.container.addChild(this.notNecessaryTitle);
            _loc6_ = 0;
            _loc7_ = 0;
            while(_loc7_ < this._info._conditions.length)
            {
               _loc8_ = this._info._conditions[_loc7_];
               _loc9_ = new QuestConditionView(_loc8_);
               if(_loc8_.isOpitional)
               {
                  _loc9_.status = this._info.conditionStatus[_loc7_];
                  if(this._info.progress[_loc7_] <= 0)
                  {
                     _loc9_.isComplete = true;
                  }
                  _loc9_.x = 0;
                  _loc9_.y = this.notNecessaryTitle.y + _loc6_ * this.CONDITION_HEIGHT + this.CONDITION_Y + this.notNecessaryTitle.height;
                  this.condArr.push(_loc9_);
                  this.container.addChild(_loc9_);
                  _loc6_++;
               }
               _loc7_++;
            }
         }
         if(this._info.RepeatMax > 1 && this._info.RepeatMax < 10000)
         {
            this._planTitle.visible = true;
            this._planTitle.y = this.condArr[this.condArr.length - 1].y + this.CONDITION_HEIGHT + this.PADDING_Y;
            this.repeatText.visible = true;
            this.repeatText.x = this._planTitle.x + this._planTitle.width;
            this.repeatText.y = this._planTitle.y;
            this.repeatText.text = String(this._info.RepeatMax - this._info.data.repeatLeft) + "/" + String(this._info.RepeatMax);
         }
         else
         {
            this._planTitle.visible = false;
            this.repeatText.visible = false;
         }
         if(this.info.QuestID == TaskManager.GUIDE_QUEST_ID)
         {
            this.canGotoConsortia(true);
         }
         else
         {
            this.canGotoConsortia(false);
         }
         this.descText.htmlText = "      " + QuestDescTextAnalyz.start(this._info.Detail);
         this.descText.height = this.descText.textHeight + this.PADDING_Y;
         if(this._planTitle.visible)
         {
            this.descText.y = this._planTitle.y + this._planTitle.height + this.PADDING_Y;
         }
         else if(this.condArr.length > 0)
         {
            this.descText.y = this.condArr[this.condArr.length - 1].height + this.condArr[this.condArr.length - 1].y;
         }
         else
         {
            this.descText.y = this.CONDITION_HEIGHT + this.CONDITION_Y + this.necessaryTitle.height;
         }
         this.descText.visible = true;
         if(this.info.QuestID == TaskManager.COLLECT_INFO_EMAIL)
         {
            this._extraFrame = this.addExtraFrame(new InfoCollectViewMail());
         }
         else if(this.info.QuestID == TaskManager.COLLECT_INFO_CELLPHONE)
         {
            this._extraFrame = this.addExtraFrame(new InfoCollectView());
         }
         this.panel.invalidateViewport();
      }
      
      private function __onGoToConsortia(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.gotoCMoive.removeEventListener(MouseEvent.CLICK,this.__onGoToConsortia);
         StateManager.setState(StateType.CONSORTIA);
      }
      
      public function canGotoConsortia(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.gotoCMoive == null)
            {
               this.gotoCMoive = ComponentFactory.Instance.creat("core.quest.GoToConsortiaBtn");
               this.gotoCMoive.addEventListener(MouseEvent.CLICK,this.__onGoToConsortia);
               this.container.addChild(this.gotoCMoive);
            }
         }
         else if(this.gotoCMoive)
         {
            this.gotoCMoive.removeEventListener(MouseEvent.CLICK,this.__onGoToConsortia);
            this.container.removeChild(this.gotoCMoive);
            this.gotoCMoive = null;
         }
      }
      
      private function addExtraFrame(param1:Sprite) : Sprite
      {
         this.container.addChild(param1);
         param1.x = 0;
         param1.y = this.descText.y;
         this.descText.y = param1.y + param1.height;
         return param1;
      }
      
      private function clear() : void
      {
         var _loc1_:QuestConditionView = null;
         this._info = null;
         this._planTitle.visible = false;
         this.descText.text = "";
         for each(_loc1_ in this.condArr)
         {
            if(_loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
            _loc1_.dispose();
         }
         if(this._extraFrame)
         {
            ObjectUtils.disposeAllChildren(this._extraFrame);
            ObjectUtils.disposeObject(this._extraFrame);
            this._extraFrame = null;
         }
         this.condArr = new Array();
      }
      
      public function get info() : QuestInfo
      {
         return this._info;
      }
      
      override public function get height() : Number
      {
         return this.descText.y + this.descText.height;
      }
      
      public function dispose() : void
      {
         var _loc1_:QuestConditionView = null;
         this._info = null;
         for each(_loc1_ in this.condArr)
         {
            if(_loc1_)
            {
               _loc1_.dispose();
            }
            _loc1_ = null;
         }
         this.condArr = null;
         if(this._BG1)
         {
            ObjectUtils.disposeObject(this._BG1);
         }
         this._BG1 = null;
         if(this._BG2)
         {
            ObjectUtils.disposeObject(this._BG2);
         }
         this._BG2 = null;
         if(this._planTitle)
         {
            ObjectUtils.disposeObject(this._planTitle);
         }
         this._planTitle = null;
         if(this._condTitle)
         {
            ObjectUtils.disposeObject(this._condTitle);
         }
         this._condTitle = null;
         if(this.notNecessaryTitle)
         {
            ObjectUtils.disposeObject(this.notNecessaryTitle);
         }
         this.notNecessaryTitle = null;
         if(this.necessaryTitle)
         {
            ObjectUtils.disposeObject(this.necessaryTitle);
         }
         this.necessaryTitle = null;
         if(this.descText)
         {
            ObjectUtils.disposeObject(this.descText);
         }
         this.descText = null;
         if(this.repeatText)
         {
            ObjectUtils.disposeObject(this.repeatText);
         }
         this.repeatText = null;
         if(this.gotoCMoive)
         {
            ObjectUtils.disposeObject(this.gotoCMoive);
         }
         this.gotoCMoive = null;
         if(this.container)
         {
            ObjectUtils.disposeObject(this.container);
         }
         this.container = null;
         if(this.panel)
         {
            ObjectUtils.disposeObject(this.panel);
         }
         this.panel = null;
         if(this._extraFrame)
         {
            ObjectUtils.disposeAllChildren(this._extraFrame);
            ObjectUtils.disposeObject(this._extraFrame);
            this._extraFrame = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
