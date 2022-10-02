package effortView.completeIcon
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortRewardInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.EffortManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.Helpers;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatFormats;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class EffortCompleteIconTipsView extends Sprite implements Disposeable, ITip
   {
      
      public static var TIP_MIN_WIDTH:int = 310;
      
      public static var TIP_MAX_HIGHT:int = 140;
      
      public static var TIP_CENTER_HIGHT:int = 115;
      
      public static var TIP_MIN_HIGHT:int = 90;
      
      public static var SPACING:int = 50;
      
      public static var OFSET:int = 5;
       
      
      private var _tipData:EffortInfo;
      
      private var _title:FilterFrameText;
      
      private var _detail:FilterFrameText;
      
      private var _honorTitle:FilterFrameText;
      
      private var _honor:FilterFrameText;
      
      private var _date:FilterFrameText;
      
      private var _achievementPointTitle:FilterFrameText;
      
      private var _achievementPoint:FilterFrameText;
      
      private var _bg:ScaleBitmapImage;
      
      private var _HRule:Image;
      
      private var _goodsTxt:TextField;
      
      public function EffortCompleteIconTipsView()
      {
         super();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortTipBg");
         addChild(this._bg);
         this._title = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortCompleteIconTipsView.EffortCompleteIconTipsText_01");
         addChild(this._title);
         this._HRule = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         addChild(this._HRule);
         this._detail = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortCompleteIconTipsView.EffortCompleteIconTipsText_02");
         addChild(this._detail);
         this._honorTitle = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortCompleteIconTipsView.EffortCompleteIconTipsText_01");
         this._honorTitle.text = LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorNameV");
         addChild(this._honorTitle);
         this._honor = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortCompleteIconTipsView.EffortCompleteIconTipsText_01");
         addChild(this._honor);
         this._date = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortCompleteIconTipsView.EffortCompleteIconTipsText_04");
         addChild(this._date);
         this._achievementPointTitle = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortCompleteIconTipsView.EffortCompleteIconTipsText_01");
         this._achievementPointTitle.text = LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.achievementPoint");
         addChild(this._achievementPointTitle);
         this._achievementPoint = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortCompleteIconTipsView.EffortCompleteIconTipsText_01");
         addChild(this._achievementPoint);
         this._goodsTxt = ComponentFactory.Instance.creatCustomObject("effortView.EffortCompleteIconTipsView.EffortCompleteIconTipsText_07I");
         this._goodsTxt.defaultTextFormat = ComponentFactory.Instance.model.getSet("EffortRightItemTextTF_08");
         this._goodsTxt.styleSheet = ChatFormats.styleSheet;
         this._goodsTxt.filters = [ComponentFactory.Instance.model.getSet("GF_7")];
         addChild(this._goodsTxt);
         this._goodsTxt.visible = false;
      }
      
      public function dispose() : void
      {
         this._bg.dispose();
         this._bg = null;
         this._title.dispose();
         this._title = null;
         this._detail.dispose();
         this._detail = null;
         this._date.dispose();
         this._date = null;
         this._achievementPoint.dispose();
         this._achievementPoint = null;
         this._achievementPointTitle.dispose();
         this._achievementPointTitle = null;
         this._honor.dispose();
         this._honor = null;
         this._honorTitle.dispose();
         this._honorTitle = null;
         ObjectUtils.disposeObject(this._goodsTxt);
         this._goodsTxt = null;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1 as EffortInfo;
         this.update();
      }
      
      private function update() : void
      {
         var _loc2_:int = 0;
         var _loc3_:ChatData = null;
         var _loc4_:int = 0;
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         this._title.text = EffortManager.Instance.splitTitle(this._tipData.Title);
         this._detail.text = this._tipData.Detail;
         var _loc1_:Date = new Date();
         if(this._tipData.CompleteStateInfo)
         {
            _loc1_ = this._tipData.CompleteStateInfo.CompletedDate;
         }
         if(this._tipData.CompleteStateInfo && EffortManager.Instance.isSelf)
         {
            this._date.text = String(_loc1_.fullYear) + "/" + String(_loc1_.month + 1) + "/" + String(_loc1_.date);
         }
         else
         {
            this._date.text = "";
         }
         this._achievementPoint.text = String(this._tipData.AchievementPoint);
         this._goodsTxt.visible = false;
         this._goodsTxt.htmlText = "";
         if(this._tipData && this._tipData.effortRewardArray)
         {
            _loc2_ = 0;
            while(_loc2_ < this._tipData.effortRewardArray.length)
            {
               _loc3_ = new ChatData();
               if((this._tipData.effortRewardArray[_loc2_] as EffortRewardInfo).RewardType == 3)
               {
                  _loc3_.htmlMessage += LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorNameIV");
                  _loc4_ = int(EffortManager.Instance.splitTitle((this._tipData.effortRewardArray[_loc2_] as EffortRewardInfo).RewardPara));
                  _loc5_ = ItemManager.Instance.getTemplateById(_loc4_);
                  _loc6_ = ChatFormats.creatGoodTag("[" + _loc5_.Name + "]",ChatFormats.CLICK_GOODS,_loc5_.TemplateID,_loc5_.Quality,true,_loc3_);
                  _loc3_.htmlMessage += _loc6_;
                  _loc7_ = "";
                  _loc7_ += Helpers.deCodeString(_loc3_.htmlMessage);
                  this._goodsTxt.htmlText = "<a>" + _loc7_ + "</a>";
                  this._goodsTxt.visible = true;
               }
               _loc2_++;
            }
         }
         this.honorName();
         this.updateComponent();
      }
      
      private function updateComponent() : void
      {
         this._date.x = this._title.x + this._title.width + OFSET;
         this._date.y = this._title.y + this._title.height - this._date.height;
         this._detail.x = this._title.x;
         this._detail.y = this._title.y + 20;
         this._HRule.x = this._detail.x - OFSET;
         this._HRule.y = this._detail.y + this._detail.height + OFSET;
         if(this._honor.text == "")
         {
            this._bg.height = TIP_MIN_HIGHT;
            this._honorTitle.visible = false;
            this._achievementPointTitle.x = this._title.x;
            this._achievementPointTitle.y = this._HRule.y + this._HRule.height + OFSET;
         }
         else
         {
            this._bg.height = TIP_CENTER_HIGHT;
            this._honorTitle.visible = true;
            this._honorTitle.x = this._title.x;
            this._honorTitle.y = this._HRule.y + this._HRule.height + OFSET;
            this._achievementPointTitle.x = this._honorTitle.x;
            this._achievementPointTitle.y = this._honorTitle.y + this._honorTitle.height + OFSET;
         }
         if(this._goodsTxt.htmlText != "")
         {
            this._bg.height = this._honor.text == "" ? Number(Number(TIP_CENTER_HIGHT)) : Number(Number(TIP_MAX_HIGHT));
            this._goodsTxt.visible = true;
            this._goodsTxt.x = this._achievementPointTitle.x;
            this._goodsTxt.y = this._achievementPointTitle.y + this._achievementPointTitle.height + OFSET;
         }
         if(this._detail.width + this._detail.x + this._date.width + SPACING > TIP_MIN_WIDTH)
         {
            this._bg.width = this._detail.width + this._detail.x + this._date.width + SPACING;
            this._HRule.width = this._bg.width - OFSET;
         }
         else
         {
            this._bg.width = TIP_MIN_WIDTH;
            this._HRule.width = TIP_MIN_WIDTH - 10;
         }
         this._honor.x = this._honorTitle.x + this._honorTitle.width;
         this._honor.y = this._honorTitle.y;
         this._achievementPoint.x = this._achievementPointTitle.x + this._achievementPointTitle.width;
         this._achievementPoint.y = this._achievementPointTitle.y;
      }
      
      private function honorName() : void
      {
         var _loc1_:int = 0;
         if(this._tipData && this._tipData.effortRewardArray)
         {
            _loc1_ = 0;
            while(_loc1_ < this._tipData.effortRewardArray.length)
            {
               if((this._tipData.effortRewardArray[_loc1_] as EffortRewardInfo).RewardType == 1)
               {
                  this._honor.text = EffortManager.Instance.splitTitle((this._tipData.effortRewardArray[_loc1_] as EffortRewardInfo).RewardPara);
               }
               _loc1_++;
            }
         }
         else
         {
            this._honor.text = "";
         }
      }
      
      public function get tipWidth() : int
      {
         return 0;
      }
      
      public function set tipWidth(param1:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
