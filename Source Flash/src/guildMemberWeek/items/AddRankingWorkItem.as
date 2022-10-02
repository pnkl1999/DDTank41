package guildMemberWeek.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class AddRankingWorkItem extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _RankingBitmp:ScaleFrameImage;
      
      private var _RankingText:FilterFrameText;
      
      private var _AddPointBookText:FilterFrameText;
      
      private var _GetPointBookText:FilterFrameText;
      
      private var _inputTxt:FilterFrameText;
      
      private var _ShowGetPointBookText:FilterFrameText;
      
      private var _PointBookBitmp:Bitmap;
      
      private var _ItemID:int = 0;
      
      public function AddRankingWorkItem()
      {
         super();
      }
      
      public function get AddMoney() : int
      {
         return int(this._inputTxt.text);
      }
      
      public function initView(param1:int) : void
      {
         this._ItemID = param1;
         if(param1 % 2 == 0)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.guildmemberweek.AddRankingFrame.ItemA");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.guildmemberweek.AddRankingFrame.ItemB");
         }
         this._RankingText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.Item.RankingTxt");
         this._AddPointBookText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.Item.AddPointBookTxt");
         this._GetPointBookText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.Item.GetPointBookTxt");
         this._ShowGetPointBookText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.Item.ShowGetPointBookTxt");
         this._PointBookBitmp = ComponentFactory.Instance.creatBitmap("swf.guildmember.MainFrame.Left.Ranking.png");
         this._PointBookBitmp.x = 327;
         this._PointBookBitmp.y = 8;
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRanking.inputTxt");
         this._inputTxt.tabEnabled = false;
         if(param1 <= 3)
         {
            this._RankingText.visible = false;
            this._RankingBitmp = ComponentFactory.Instance.creat("toffilist.guildMemberWeektopThreeRink");
            this._RankingBitmp.setFrame(param1);
            this._RankingBitmp.y = 4;
            this._RankingBitmp.x = -4;
         }
         else
         {
            this._RankingText.visible = true;
         }
         addChild(this._bg);
         addChild(this._RankingText);
         if(this._RankingBitmp)
         {
            addChild(this._RankingBitmp);
         }
         addChild(this._AddPointBookText);
         addChild(this._GetPointBookText);
         addChild(this._ShowGetPointBookText);
         addChild(this._PointBookBitmp);
         addChild(this._inputTxt);
         this.initText();
         this.initEvent();
      }
      
      public function initText() : void
      {
         this._AddPointBookText.text = LanguageMgr.GetTranslation("money");
         this._GetPointBookText.text = LanguageMgr.GetTranslation("money");
         this._RankingText.text = this._ItemID + "th";
         this._ShowGetPointBookText.text = "0";
         this._inputTxt.text = "0";
      }
      
      public function initEvent() : void
      {
         addEventListener(KeyboardEvent.KEY_UP,this.__ItemWorkCheckKeyboard);
         addEventListener(FocusEvent.FOCUS_OUT,this.__ItemWorkFocusEvent);
      }
      
      private function RemoveEvent() : void
      {
         removeEventListener(KeyboardEvent.KEY_UP,this.__ItemWorkCheckKeyboard);
         removeEventListener(FocusEvent.FOCUS_OUT,this.__ItemWorkFocusEvent);
      }
      
      private function __ItemWorkCheckKeyboard(param1:KeyboardEvent) : void
      {
         this._ItemWork();
      }
      
      private function __ItemWorkFocusEvent(param1:FocusEvent) : void
      {
         this._ItemWork();
      }
      
      private function _ItemWork() : void
      {
         var _loc6_:Number = NaN;
         if(this._inputTxt.text == "")
         {
            this._inputTxt.text = "0";
         }
         var _loc1_:Number = Number(this._inputTxt.text);
         var _loc2_:Number = 0;
         var _loc3_:int = this._ItemID - 1;
         var _loc4_:int = 0;
         var _loc5_:int = GuildMemberWeekManager.instance.model.PlayerAddPointBook.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc4_ != _loc3_)
            {
               _loc2_ += GuildMemberWeekManager.instance.model.PlayerAddPointBook[_loc4_];
            }
            _loc4_++;
         }
         if(_loc1_ < 0)
         {
            _loc1_ = PlayerManager.Instance.Self.Money - _loc2_;
         }
         else
         {
            _loc6_ = _loc2_ + _loc1_;
            if(_loc6_ >= PlayerManager.Instance.Self.Money)
            {
               _loc1_ = PlayerManager.Instance.Self.Money - _loc2_;
            }
         }
         this._inputTxt.text = String(_loc1_);
         GuildMemberWeekManager.instance.Controller.upPointBookData(this._ItemID,_loc1_);
      }
      
      public function ChangeGetPointBook(param1:int) : void
      {
         this._ShowGetPointBookText.text = String(param1);
      }
      
      public function dispose() : void
      {
         this.RemoveEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._RankingText);
         this._RankingText = null;
         if(this._RankingBitmp)
         {
            ObjectUtils.disposeObject(this._RankingBitmp);
         }
         this._RankingBitmp = null;
         ObjectUtils.disposeObject(this._AddPointBookText);
         this._AddPointBookText = null;
         ObjectUtils.disposeObject(this._GetPointBookText);
         this._GetPointBookText = null;
         ObjectUtils.disposeObject(this._ShowGetPointBookText);
         this._ShowGetPointBookText = null;
         ObjectUtils.disposeObject(this._PointBookBitmp);
         this._PointBookBitmp = null;
         ObjectUtils.disposeObject(this._inputTxt);
         this._inputTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
