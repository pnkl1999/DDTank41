package luckStar.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import luckStar.model.LuckStarPlayerInfo;
   
   public class LuckStarRankItem extends Sprite implements Disposeable
   {
       
      
      private var _vipName:GradientText;
      
      private var _rankName:FilterFrameText;
      
      private var _rankText:FilterFrameText;
      
      private var _rankScore:FilterFrameText;
      
      private var _rankIcon:ScaleFrameImage;
      
      private var _info:LuckStarPlayerInfo;
      
      public function LuckStarRankItem()
      {
         super();
         this._rankIcon = ComponentFactory.Instance.creat("luckyStar.rankItem.topThreeRink");
         this._rankText = ComponentFactory.Instance.creat("luckyStar.rankItem.rankText");
         this._rankScore = ComponentFactory.Instance.creat("luckyStar.rankItem.rankScore");
         this._vipName = ComponentFactory.Instance.creat("luckyStar.rankItem.gradueteNumText");
         this._rankName = ComponentFactory.Instance.creat("luckyStar.rankItem.rankNmaeText");
         addChild(this._rankIcon);
         addChild(this._rankText);
         addChild(this._rankScore);
         addChild(this._vipName);
         addChild(this._rankName);
         this.resetItem();
      }
      
      public function set info(param1:LuckStarPlayerInfo) : void
      {
         this._info = param1;
         this.updateView();
      }
      
      private function updateView() : void
      {
         this.updateRank();
         this.updateName();
         this.updateScore();
      }
      
      public function resetItem() : void
      {
         this._rankIcon.visible = false;
         this._rankText.visible = false;
         this._rankName.visible = false;
         this._vipName.visible = false;
         this._rankScore.text = "";
      }
      
      private function updateRank() : void
      {
         this._rankIcon.visible = false;
         this._rankText.visible = false;
         if(this._info.rank < 4)
         {
            this._rankIcon.visible = true;
            this._rankIcon.setFrame(this._info.rank);
            return;
         }
         this._rankText.visible = true;
         this._rankText.text = this._info.rank + "th";
      }
      
      private function updateName() : void
      {
         var _loc1_:int = 133;
         var _loc2_:int = 60;
         this._rankName.visible = false;
         this._vipName.visible = false;
         if(this._info.isVip)
         {
            this._vipName.visible = true;
            this._vipName.text = this._info.name;
            if(this._vipName.width < _loc1_)
            {
               this._vipName.x = _loc2_ + (_loc1_ - this._vipName.width) / 2;
            }
            else if(this._vipName.width > _loc1_)
            {
               this._vipName.width = _loc1_;
               this._vipName.x = _loc2_;
            }
            return;
         }
         this._rankName.visible = true;
         this._rankName.text = this._info.name;
      }
      
      private function updateScore() : void
      {
         this._rankScore.text = this._info.starNum.toString();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._rankIcon);
         this._rankIcon = null;
         ObjectUtils.disposeObject(this._rankText);
         this._rankText = null;
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
         ObjectUtils.disposeObject(this._rankScore);
         this._rankScore = null;
         ObjectUtils.disposeObject(this._rankName);
         this._rankName = null;
         this._info = null;
      }
   }
}
