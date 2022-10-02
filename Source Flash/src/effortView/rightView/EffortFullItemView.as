package effortView.rightView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortRewardInfo;
   import ddt.manager.EffortManager;
   import ddt.manager.PlayerManager;
   import effortView.completeIcon.EffortCompleteIconView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class EffortFullItemView extends Sprite implements Disposeable
   {
      
      public static const ICON_SCALE:Number = 0.76;
      
      public static const POINTVIEW_SCALE:Number = 0.8;
       
      
      private var _info:EffortInfo;
      
      private var _isSelect:Boolean;
      
      private var _effortIcon:EffortIconView;
      
      private var _achievementPointView:AchievementPointView;
      
      private var _titleText:FilterFrameText;
      
      private var _detailText:FilterFrameText;
      
      private var _dateText:FilterFrameText;
      
      private var _bg:Bitmap;
      
      private var _effortCompleteIconView:EffortCompleteIconView;
      
      public function EffortFullItemView(param1:EffortInfo = null)
      {
         this._info = param1;
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.Effort.EffortFullItemBG");
         addChild(this._bg);
         this._titleText = ComponentFactory.Instance.creat("effortView.EffortScaleStrip.EffortFullItemText_01");
         addChild(this._titleText);
         this._detailText = ComponentFactory.Instance.creat("effortView.EffortScaleStrip.EffortFullItemText_02");
         addChild(this._detailText);
         this._dateText = ComponentFactory.Instance.creat("effortView.EffortScaleStrip.EffortFullItemText_03");
         addChild(this._dateText);
         this._effortIcon = new EffortIconView();
         this._effortIcon.x = 5;
         this._effortIcon.y = 2;
         this._effortIcon.scaleX = ICON_SCALE;
         this._effortIcon.scaleY = ICON_SCALE;
         addChild(this._effortIcon);
         this._achievementPointView = new AchievementPointView();
         _loc1_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortFullView.EffortIconViewPos_0");
         this._achievementPointView.x = _loc1_.x;
         this._achievementPointView.y = _loc1_.y;
         this._achievementPointView.scaleX = POINTVIEW_SCALE;
         this._achievementPointView.scaleY = POINTVIEW_SCALE;
         addChild(this._achievementPointView);
         this._effortCompleteIconView = new EffortCompleteIconView();
         _loc2_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortFullView.EffortIconViewPos_1");
         this._effortCompleteIconView.x = _loc2_.x;
         this._effortCompleteIconView.y = _loc2_.y;
         this._effortCompleteIconView.visible = false;
         addChild(this._effortCompleteIconView);
         this.update();
      }
      
      private function update() : void
      {
         var _loc2_:int = 0;
         if(!this._info)
         {
            return;
         }
         this._titleText.text = this.splitTitle();
         this._titleText.x = this._bg.width / 2 - this._titleText.width / 2;
         this._detailText.text = this._info.Detail;
         this._detailText.x = this._bg.width / 2 - this._detailText.width / 2;
         this._effortIcon.iconUrl = String(this._info.picId);
         this._achievementPointView.value = this._info.AchievementPoint;
         var _loc1_:Date = new Date();
         if(this._info.CompleteStateInfo)
         {
            _loc1_ = this._info.CompleteStateInfo.CompletedDate;
         }
         if(this._info.CompleteStateInfo && EffortManager.Instance.isSelf)
         {
            this._dateText.text = String(_loc1_.fullYear) + "/" + String(_loc1_.month + 1) + "/" + String(_loc1_.date);
         }
         else
         {
            this._dateText.text = "";
         }
         if(this._info.effortRewardArray)
         {
            _loc2_ = 0;
            while(_loc2_ < this._info.effortRewardArray.length)
            {
               if((this._info.effortRewardArray[_loc2_] as EffortRewardInfo).RewardType == 1)
               {
                  this._effortCompleteIconView.setInfo(this._info);
                  this._effortCompleteIconView.visible = true;
               }
               _loc2_++;
            }
         }
      }
      
      private function splitTitle() : String
      {
         var _loc1_:Array = [];
         if(this._info)
         {
            _loc1_ = this._info.Title.split("/");
            if(_loc1_.length > 1 && _loc1_[1] != "")
            {
               if(PlayerManager.Instance.Self.Sex)
               {
                  return _loc1_[0];
               }
               return _loc1_[1];
            }
            return _loc1_[0];
         }
         return "";
      }
      
      public function dispose() : void
      {
         this._effortIcon.dispose();
         this._effortIcon = null;
         this._achievementPointView.dispose();
         this._achievementPointView = null;
         this._titleText.dispose();
         this._titleText = null;
         this._detailText.dispose();
         this._detailText = null;
         this._dateText.dispose();
         this._dateText = null;
         this._bg.bitmapData.dispose();
         this._bg = null;
         this._effortCompleteIconView.dispose();
         this._effortCompleteIconView = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
