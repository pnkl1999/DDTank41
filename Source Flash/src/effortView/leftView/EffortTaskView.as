package effortView.leftView
{
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.events.TaskEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import quest.QuestRewardCell;
   
   public class EffortTaskView extends Sprite implements Disposeable
   {
       
      
      private var _bg:MovieImage;
      
      private var _rewardBtn:SimpleBitmapButton;
      
      private var _titleText:FilterFrameText;
      
      private var _valueText:FilterFrameText;
      
      private var _cell:QuestRewardCell;
      
      private var _questInfo:QuestInfo;
      
      private var _itemTemplateinfo:ItemTemplateInfo;
      
      private var _light:IEffect;
      
      public function EffortTaskView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.Effort.effortTaskBg");
         addChild(this._bg);
         this._rewardBtn = ComponentFactory.Instance.creat("effortView.EffortTaskView.EffortTaskViewRewardBtn");
         addChild(this._rewardBtn);
         this._titleText = ComponentFactory.Instance.creat("effortView.EffortTaskView.EffortTaskText_01");
         addChild(this._titleText);
         this._valueText = ComponentFactory.Instance.creat("effortView.EffortTaskView.EffortTaskText_02");
         addChild(this._valueText);
         this._light = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._rewardBtn,"asset.Effort.RewardBtn","asset.effort.light_mc",new Point(0,0),new Point(-3,-3));
         this._light.play();
         this.initQuestInfo();
      }
      
      private function initQuestInfo() : void
      {
         var _loc1_:Point = null;
         var _loc3_:InventoryItemInfo = null;
         _loc1_ = null;
         _loc3_ = null;
         this._questInfo = TaskManager.achievementQuest;
         if(!this._questInfo)
         {
            return;
         }
         this._cell = new QuestRewardCell();
         this._cell.taskType = 1;
         this._cell.opitional = false;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortTaskView.CellPos");
         this._cell.x = _loc1_.x;
         this._cell.y = _loc1_.y;
         var _loc2_:QuestItemReward = new QuestItemReward(11408,2,"","true");
         _loc3_ = new InventoryItemInfo();
         _loc3_.ValidDate = _loc2_.ValidateTime;
         _loc3_.TemplateID = 11408;
         _loc3_.IsJudge = true;
         _loc3_.IsBinds = _loc2_.isBind;
         _loc3_.AttackCompose = _loc2_.AttackCompose;
         _loc3_.DefendCompose = _loc2_.DefendCompose;
         _loc3_.AgilityCompose = _loc2_.AgilityCompose;
         _loc3_.LuckCompose = _loc2_.LuckCompose;
         _loc3_.StrengthenLevel = _loc2_.StrengthenLevel;
         _loc3_.Count = _loc2_.count;
         if(_loc2_.IsCount && this._questInfo.data && this._questInfo.data.quality)
         {
            _loc3_.Count = _loc2_.count * this._questInfo.data.quality;
         }
         ItemManager.fill(_loc3_);
         if(_loc3_ && _loc3_.TemplateID != 0)
         {
            this._cell.visible = true;
            this._cell.info = _loc3_;
         }
         addChild(this._cell);
         this.updateText();
      }
      
      private function updateText() : void
      {
         if(!this._questInfo)
         {
            return;
         }
         this._titleText.text = this._questInfo.Detail;
         var _loc1_:int = this._questInfo._conditions[0].param2 - this._questInfo.data.progress[0];
         _loc1_ = _loc1_ > this._questInfo._conditions[0].param2 ? int(int(_loc1_)) : int(int(this._questInfo._conditions[0].param2));
         var _loc2_:int = this._questInfo._conditions[0].param2 - this._questInfo.data.progress[0];
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > 5)
         {
            _loc2_ = 5;
         }
         this._valueText.text = "(" + String(_loc2_) + "/" + String(this._questInfo._conditions[0].param2) + ")";
         this.btnEnable();
      }
      
      private function btnEnable() : void
      {
         if(!this._questInfo || !this._rewardBtn)
         {
            return;
         }
         if(this._questInfo.data.progress[0] <= 0)
         {
            this._rewardBtn.enable = true;
            this._light.play();
         }
         else
         {
            this._rewardBtn.enable = false;
            this._light.stop();
         }
      }
      
      private function initEvent() : void
      {
         this._rewardBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         TaskManager.addEventListener(TaskEvent.CHANGED,this.__update);
      }
      
      private function __update(param1:TaskEvent) : void
      {
         this.updateText();
         this.btnEnable();
      }
      
      private function __btnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._questInfo)
         {
            TaskManager.requestAchievementReward();
            this.updateText();
         }
      }
      
      public function dispose() : void
      {
         if(this._rewardBtn)
         {
            this._rewardBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         }
         TaskManager.removeEventListener(TaskEvent.CHANGED,this.__update);
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._rewardBtn && this._rewardBtn.parent)
         {
            this._rewardBtn.parent.removeChild(this._rewardBtn);
            this._rewardBtn.dispose();
            this._rewardBtn = null;
         }
         if(this._titleText && this._titleText.parent)
         {
            this._titleText.parent.removeChild(this._titleText);
            this._titleText.dispose();
            this._titleText = null;
         }
         if(this._valueText && this._valueText.parent)
         {
            this._valueText.parent.removeChild(this._valueText);
            this._valueText.dispose();
            this._valueText = null;
         }
      }
   }
}
