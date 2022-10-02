package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.TaskManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class QuestRewardView extends Sprite implements Disposeable
   {
       
      
      private const ROW_HEIGHT:int = 24;
      
      private const ROW_X:int = 18;
      
      private const REWARDCELL_HEIGHT:int = 55;
      
      private var _info:QuestInfo;
      
      private var _optionalItemAwards:Array;
      
      private var _constantItemAwards:Array;
      
      private var _itemAwardCells:Array;
      
      private var _optionalCellArr:Array;
      
      private var _itemAwardPosX:Number;
      
      private var _itemAwardPosY:Number;
      
      private var _bg:ScaleFrameImage;
      
      private var itemsTitle_mc:Bitmap;
      
      private var cardAsset:ScaleFrameImage;
      
      private var rewardArr:Array;
      
      private var _style:int;
      
      private var _eligiblyWord:ScaleFrameImage;
      
      private var _eligiblyBG:ScaleFrameImage;
      
      public function QuestRewardView()
      {
         super();
         this.rewardArr = new Array();
         this._optionalCellArr = new Array();
         this.initView();
      }
      
      public function set info(param1:QuestInfo) : void
      {
         this._info = param1;
         this.update();
      }
      
      public function set taskStyle(param1:int) : void
      {
         this._bg.setFrame(param1 == TaskMainFrame.NORMAL ? int(int(1)) : int(int(2)));
         this._eligiblyWord.setFrame(param1 == TaskMainFrame.NORMAL ? int(int(1)) : int(int(2)));
         this._eligiblyBG.setFrame(param1 == TaskMainFrame.NORMAL ? int(int(1)) : int(int(2)));
         this._style = param1;
      }
      
      private function initView() : void
      {
         this.itemsTitle_mc = ComponentFactory.Instance.creat("asset.core.quest.RewardText.OptionalTitle");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.quest.awardBGStyle");
         this._eligiblyBG = ComponentFactory.Instance.creatComponentByStylename("core.quest.eligiblyBG");
         this._eligiblyWord = ComponentFactory.Instance.creatComponentByStylename("core.quest.eligiblyWord");
         this._eligiblyWord.visible = false;
         this._eligiblyBG.visible = false;
         addChild(this._bg);
         addChild(this.itemsTitle_mc);
         addChild(this._eligiblyBG);
         addChild(this._eligiblyWord);
      }
      
      public function get optionalCells() : Array
      {
         return this._optionalCellArr;
      }
      
      private function get _cell() : QuestRewardCell
      {
         return this._itemAwardCells[this._itemAwardCells.length];
      }
      
      private function getSexByInt(param1:Boolean) : int
      {
         if(param1)
         {
            return 1;
         }
         return 2;
      }
      
      private function update() : void
      {
         var _loc4_:int = 0;
         var _loc5_:FilterFrameText = null;
         var _loc1_:QuestItemReward = null;
         var _loc2_:int = 0;
         var _loc3_:InventoryItemInfo = null;
         _loc4_ = 0;
         _loc5_ = null;
         this.dropView();
         TaskManager.itemAwardSelected = 0;
         this._itemAwardPosY = this.ROW_HEIGHT + this.itemsTitle_mc.y;
         for each(_loc1_ in this._info.itemRewards)
         {
            _loc3_ = new InventoryItemInfo();
            _loc3_.TemplateID = _loc1_.itemID;
            ItemManager.fill(_loc3_);
            if(!(0 != _loc3_.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != _loc3_.NeedSex))
            {
               if(_loc1_.isOptional == 0)
               {
                  this._constantItemAwards.push(_loc1_);
               }
               else if(_loc1_.isOptional == 1)
               {
                  this._optionalItemAwards.push(_loc1_);
               }
            }
         }
         _loc2_ = 0;
         if(this._info.RewardGP > 0)
         {
            this.addReward("exp",this._info.RewardGP,_loc2_);
            _loc2_++;
         }
         if(this._info.RewardGold > 0)
         {
            this.addReward("gold",this._info.RewardGold,_loc2_);
            _loc2_++;
         }
         if(this._info.RewardMoney > 0)
         {
            this.addReward("coin",this._info.RewardMoney,_loc2_);
            _loc2_++;
         }
         if(this._info.RewardOffer > 0)
         {
            this.addReward("honor",this._info.RewardOffer,_loc2_);
            _loc2_++;
         }
         if(this._info.RewardRiches > 0)
         {
            this.addReward("rich",this._info.RewardRiches,_loc2_);
            _loc2_++;
         }
         if(this._info.RewardGiftToken > 0)
         {
            this.addReward("gift",this._info.RewardGiftToken,_loc2_);
            _loc2_++;
         }
         if(this._info.RewardMedal > 0)
         {
            this.addReward("medal",this._info.RewardMedal,_loc2_);
            _loc2_++;
         }
         if(this._info.Rank != "")
         {
            this.addReward("rank",0,_loc2_,true,this._info.Rank);
            _loc2_++;
         }
         this._itemAwardPosX = 10;
         this._itemAwardPosY += Math.ceil(_loc2_ / 4) * this.ROW_HEIGHT;
         if(this._info.RewardBuffID != 0)
         {
            this.cardAsset = ComponentFactory.Instance.creat("core.quest.MCQuestRewardBuff");
            addChild(this.cardAsset);
            this.cardAsset.x = this.ROW_X;
            this.cardAsset.y = this._itemAwardPosY;
            this._itemAwardPosY += this.ROW_HEIGHT;
            this.cardAsset.setFrame(this._info.RewardBuffID - 11994);
            _loc4_ = this._info.RewardBuffDate;
            if(this._info.data && this._info.data.quality)
            {
               _loc4_ *= this._info.data.quality;
            }
            _loc5_ = ComponentFactory.Instance.creat("core.quest.QuestItemRewardQuantity");
            addChild(_loc5_);
            _loc5_.x = this.cardAsset.x + this.cardAsset.width + 2;
            _loc5_.y = this.cardAsset.y;
            _loc5_.text = String(_loc4_) + LanguageMgr.GetTranslation("hours");
            this.rewardArr.push(this.cardAsset);
            this.rewardArr.push(_loc5_);
         }
         this.drawItemAwardSet(this._constantItemAwards);
         this._itemAwardPosY += Math.ceil(this._constantItemAwards.length / 2) * this.REWARDCELL_HEIGHT;
         if(this._optionalItemAwards.length > 0)
         {
            this._eligiblyWord.y = this._itemAwardPosY;
            this._eligiblyWord.visible = true;
            this._eligiblyBG.y = this._itemAwardPosY;
            this._eligiblyBG.height = Math.ceil(this._optionalItemAwards.length / 2) * this.REWARDCELL_HEIGHT + 15;
            this._eligiblyBG.visible = true;
            this._itemAwardPosY += 22;
            this.drawItemAwardSet(this._optionalItemAwards,true);
            this._itemAwardPosY += Math.ceil(this._optionalItemAwards.length / 2) * this.REWARDCELL_HEIGHT;
         }
         else
         {
            this._eligiblyWord.visible = false;
            this._eligiblyBG.visible = false;
         }
         this._bg.height = this._itemAwardPosY > 220 ? Number(Number(this._itemAwardPosY + 10)) : Number(Number(220));
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      private function drawItemAwardSet(param1:Array, param2:Boolean = false) : void
      {
         var _loc4_:QuestRewardCell = null;
         _loc4_ = null;
         var _loc5_:QuestItemReward = null;
         var _loc6_:InventoryItemInfo = null;
         if(param1.length <= 0)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new QuestRewardCell();
            _loc4_.taskType = this._style;
            _loc4_.opitional = param2;
            _loc4_.x = _loc3_ % 2 * 186 + this.ROW_X;
            _loc4_.y = this._itemAwardPosY + int(_loc3_ / 2) * this.REWARDCELL_HEIGHT;
            _loc5_ = param1[_loc3_];
            _loc6_ = new InventoryItemInfo();
            _loc6_.ValidDate = _loc5_.ValidateTime;
            _loc6_.TemplateID = _loc5_.itemID;
            _loc6_.IsJudge = true;
            _loc6_.IsBinds = _loc5_.isBind;
            _loc6_.AttackCompose = _loc5_.AttackCompose;
            _loc6_.DefendCompose = _loc5_.DefendCompose;
            _loc6_.AgilityCompose = _loc5_.AgilityCompose;
            _loc6_.LuckCompose = _loc5_.LuckCompose;
            _loc6_.StrengthenLevel = _loc5_.StrengthenLevel;
            _loc6_.Count = _loc5_.count;
            if(_loc5_.IsCount && this._info.data && this._info.data.quality)
            {
               _loc6_.Count = _loc5_.count * this._info.data.quality;
            }
            ItemManager.fill(_loc6_);
            if(_loc6_ && _loc6_.TemplateID != 0)
            {
               _loc4_.visible = true;
               _loc4_.info = _loc6_;
               this._itemAwardCells.push(_loc4_);
               if(param2)
               {
                  TaskManager.itemAwardSelected = -1;
                  _loc4_.canBeSelected();
                  _loc4_.addEventListener(RewardSelectedEvent.ITEM_SELECTED,this.__chooseItemReward);
                  this._optionalCellArr.push(_loc4_);
               }
               addChild(_loc4_);
            }
            else
            {
               _loc4_.visible = false;
               if(_loc4_.parent)
               {
                  _loc4_.parent.removeChild(_loc4_);
               }
               _loc4_ = null;
            }
            _loc3_++;
         }
      }
      
      private function __chooseItemReward(param1:RewardSelectedEvent) : void
      {
         var _loc2_:QuestRewardCell = null;
         for each(_loc2_ in this._itemAwardCells)
         {
            _loc2_.selected = false;
         }
         param1.itemCell.selected = true;
      }
      
      private function addReward(param1:String, param2:int, param3:int, param4:Boolean = false, param5:String = "") : void
      {
         var _loc7_:FilterFrameText = null;
         if(param1 == "medal")
         {
            return;
         }
         var _loc6_:ScaleFrameImage = ComponentFactory.Instance.creat("core.quest.MCQuestRewardType");
         _loc7_ = ComponentFactory.Instance.creat("core.quest.QuestItemRewardQuantity");
         switch(param1)
         {
            case "exp":
               _loc6_.setFrame(1);
               break;
            case "gold":
               _loc6_.setFrame(2);
               break;
            case "coin":
               _loc6_.setFrame(3);
               break;
            case "rich":
               _loc6_.setFrame(4);
               break;
            case "honor":
               _loc6_.setFrame(5);
               break;
            case "gift":
               _loc6_.setFrame(6);
               break;
            case "medal":
               _loc6_.setFrame(7);
               break;
            case "rank":
               _loc6_.setFrame(8);
			   break;
         }
         _loc6_.x = param3 % 4 * 90 + this.ROW_X;
         _loc6_.y = int(param3 / 4) * 25 + this._itemAwardPosY;
         _loc7_.x = _loc6_.x + _loc6_.width + 2;
         _loc7_.y = _loc6_.y;
         if(param4)
         {
            _loc7_.text = param5;
         }
         else
         {
            if(this._info.data && this._info.data.quality)
            {
               param2 *= this._info.data.quality;
            }
            _loc7_.text = String(param2);
         }
         addChild(_loc6_);
         addChild(_loc7_);
         this.rewardArr.push(_loc6_);
         this.rewardArr.push(_loc7_);
      }
      
      private function dropView() : void
      {
         var _loc1_:QuestItemReward = null;
         var _loc2_:QuestItemReward = null;
         var _loc3_:Disposeable = null;
         var _loc4_:QuestRewardCell = null;
         var _loc5_:QuestRewardCell = null;
         for each(_loc1_ in this._optionalItemAwards)
         {
            _loc1_ = null;
         }
         for each(_loc2_ in this._constantItemAwards)
         {
            _loc2_ = null;
         }
         for each(_loc3_ in this.rewardArr)
         {
            if(_loc3_)
            {
               _loc3_.dispose();
            }
            _loc3_ = null;
         }
         for each(_loc4_ in this._itemAwardCells)
         {
            if(_loc4_)
            {
               _loc4_.dispose();
            }
            _loc4_ = null;
         }
         for each(_loc5_ in this._optionalCellArr)
         {
            _loc5_ = null;
         }
         this.rewardArr = new Array();
         this._itemAwardCells = new Array();
         this._constantItemAwards = new Array();
         this._optionalItemAwards = new Array();
         this._optionalCellArr = new Array();
      }
      
      public function dispose() : void
      {
         this._info = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this.itemsTitle_mc)
         {
            ObjectUtils.disposeObject(this.itemsTitle_mc);
         }
         this.itemsTitle_mc = null;
         if(this.cardAsset)
         {
            ObjectUtils.disposeObject(this.cardAsset);
         }
         this.cardAsset = null;
         if(this._eligiblyWord)
         {
            ObjectUtils.disposeObject(this._eligiblyWord);
         }
         this._eligiblyWord = null;
         if(this._eligiblyBG)
         {
            ObjectUtils.disposeObject(this._eligiblyBG);
         }
         this._eligiblyBG = null;
         this.dropView();
         this.rewardArr = null;
         this._itemAwardCells = null;
         this._constantItemAwards = null;
         this._optionalItemAwards = null;
         this._optionalCellArr = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
