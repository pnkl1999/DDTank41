package guildMemberWeek.items
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class ShowGuildMemberDataItem extends Sprite implements Disposeable
   {
       
      
      private var _RankingBitmp:ScaleFrameImage;
      
      private var _RankingText:FilterFrameText;
      
      private var _MemberNameText:FilterFrameText;
      
      private var _MemberContributeText:FilterFrameText;
      
      private var _AddRankingText:FilterFrameText;
      
      private var _AddRankingBtn:BaseButton;
      
      private var _AddRankingSprite:Sprite;
      
      private var _AddRankingBg:Bitmap;
      
      private var _itemCells:Array;
      
      public var Count:int = 1;
      
      private var _templateInfo:ItemTemplateInfo;
      
      public function ShowGuildMemberDataItem()
      {
         super();
      }
      
      public function GetTemplateInfo(param1:int) : ItemTemplateInfo
      {
         return ItemManager.Instance.getTemplateById(param1);
      }
      
      public function initView(param1:int) : void
      {
         this._RankingText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.MainFrame.left.ShowGuildMemberDataItem.RankingTxt");
         this._RankingText.text = param1 + "th";
         this._MemberNameText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.MainFrame.left.ShowGuildMemberDataItem.MemberNameTxt");
         this._MemberContributeText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.MainFrame.left.ShowGuildMemberDataItem.MemberContributeTxt");
         this._AddRankingText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.MainFrame.left.ShowGuildMemberDataItem.AddRankingTxt");
         this._AddRankingBg = ComponentFactory.Instance.creatBitmap("swf.guildmember.MainFrame.Left.Ranking.png");
         this._AddRankingSprite = new Sprite();
         this._AddRankingSprite.addChild(this._AddRankingBg);
         this._AddRankingSprite.addChild(this._AddRankingText);
         this._AddRankingBtn = GuildMemberWeekManager.instance.returnComponentBnt(this._AddRankingSprite);
         this._AddRankingBtn.y = 5;
         this._AddRankingBtn.x = 465;
         this._AddRankingBtn.buttonMode = false;
         if(param1 <= 3)
         {
            this._RankingText.visible = false;
            this._RankingBitmp = ComponentFactory.Instance.creat("toffilist.guildMemberWeektopThreeRink");
            this._RankingBitmp.setFrame(param1);
         }
         else
         {
            this._RankingText.visible = true;
         }
         addChild(this._RankingText);
         addChild(this._MemberNameText);
         addChild(this._MemberContributeText);
         addChild(this._AddRankingBtn);
         addChild(this._AddRankingSprite);
         if(this._RankingBitmp)
         {
            addChild(this._RankingBitmp);
         }
      }
      
      protected function creatItemCell() : BaseCell
      {
         var _loc2_:BaseCell = null;
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,30,30);
         _loc1_.graphics.endFill();
         _loc2_ = new BaseCell(_loc1_,null,true,true);
         _loc2_.tipDirctions = "7,6,2,1,5,4,0,3,6";
         _loc2_.tipGapV = 10;
         _loc2_.tipGapH = 10;
         _loc2_.tipStyle = "core.GoodsTip";
         return _loc2_;
      }
      
      public function initMember(param1:String, param2:String) : void
      {
         this._MemberNameText.text = param1;
         this._MemberContributeText.text = param2;
      }
      
      public function initAddPointBook(param1:int) : void
      {
         this._AddRankingText.text = String(param1);
         this._AddRankingBtn.tipData = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.CanGetPointBook") + this._AddRankingText.text;
         this._AddRankingBtn.tipGapH = 520;
      }
      
      public function initItemCell(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BaseCell = null;
         var _loc10_:FilterFrameText = null;
         this._itemCells = new Array();
         _loc2_ = param1.split(",");
         _loc3_ = 0;
         var _loc4_:int = _loc2_.length;
         var _loc5_:Point = PositionUtils.creatPoint("guildMemberWeek.ShowGift.cellPos");
         var _loc6_:int = _loc5_.x;
         var _loc7_:int = _loc5_.y;
         _loc8_ = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc9_ = this.creatItemCell();
            _loc9_.buttonMode = true;
            _loc9_.width = 30;
            _loc9_.height = 30;
            _loc9_.info = this.GetTemplateInfo(int(_loc2_[_loc3_]));
            _loc9_.buttonMode = true;
            _loc9_.x = _loc6_ + _loc8_ * 35;
            _loc9_.y = _loc7_;
            _loc10_ = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.left.giftNumberShowTxt");
            _loc10_.text = "";
            if(_loc2_[_loc3_ + 1] != undefined)
            {
               _loc10_.text = _loc2_[_loc3_ + 1];
            }
            _loc9_.addChild(_loc10_);
            this._itemCells.push([_loc9_,_loc10_,int(_loc2_[_loc3_ + 1])]);
            addChild(_loc9_);
            _loc8_++;
            _loc3_ += 2;
         }
      }
      
      private function disposeItemCell() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._itemCells)
         {
            _loc1_ = this._itemCells.length;
            _loc2_ = 0;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               ObjectUtils.disposeObject(this._itemCells[_loc2_][1]);
               ObjectUtils.disposeObject(this._itemCells[_loc2_][0]);
               this._itemCells[_loc2_][0] = null;
               this._itemCells[_loc2_][1] = null;
               this._itemCells[_loc2_][2] = null;
               this._itemCells[_loc2_] = null;
               _loc2_++;
            }
            this._itemCells = null;
         }
      }
      
      public function dispose() : void
      {
         this.disposeItemCell();
         ObjectUtils.disposeObject(this._RankingText);
         this._RankingText = null;
         ObjectUtils.disposeObject(this._MemberNameText);
         this._MemberNameText = null;
         ObjectUtils.disposeObject(this._MemberContributeText);
         this._MemberContributeText = null;
         ObjectUtils.disposeAllChildren(this._AddRankingBtn);
         ObjectUtils.disposeObject(this._AddRankingBtn);
         this._AddRankingBtn = null;
         if(this._RankingBitmp)
         {
            ObjectUtils.disposeObject(this._RankingBitmp);
         }
         this._RankingBitmp = null;
         if(this._AddRankingSprite)
         {
            ObjectUtils.disposeAllChildren(this._AddRankingSprite);
         }
         this._AddRankingSprite = null;
         this._AddRankingBg = null;
         this._AddRankingText = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
