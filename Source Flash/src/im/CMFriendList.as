package im
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.CMFriendInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   
   public class CMFriendList extends Sprite implements Disposeable
   {
      
      public static const LIST_MAX_NUM:int = 5;
       
      
      private var _list:VBox;
      
      private var _CMFriendArray:Array;
      
      private var _CMFriendItemArray:Array;
      
      private var _title:IMListItemView;
      
      private var _titleInfo:FriendListPlayer;
      
      private var _titleII:IMListItemView;
      
      private var _titleInfoII:FriendListPlayer;
      
      private var _currentTitleInfo:FriendListPlayer;
      
      private var _playCurrentPage:int;
      
      private var _playDDTListTotalPage:int;
      
      private var _unplayCurrentPage:int;
      
      private var _unplayDDTListTotalPage:int;
      
      private var _upPageBtn:BaseButton;
      
      private var _downPageBtn:BaseButton;
      
      private var _InviteBlogBtn:BaseButton;
      
      private var _switchBtn1:SelectedCheckButton;
      
      private var _switchBtn2:SelectedCheckButton;
      
      private var _currentCMFInfo:CMFriendInfo;
      
      public function CMFriendList()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("IM.CMFriendList.CMFriendList");
         addChild(this._list);
         this._CMFriendItemArray = [];
         this._upPageBtn = ComponentFactory.Instance.creatComponentByStylename("IM.CMFriendList.upPageBtn");
         addChild(this._upPageBtn);
         this._downPageBtn = ComponentFactory.Instance.creatComponentByStylename("IM.CMFriendList.downPageBtn");
         addChild(this._downPageBtn);
         this._InviteBlogBtn = ComponentFactory.Instance.creatComponentByStylename("IM.CMFriendList.InviteBlogBtn");
         addChild(this._InviteBlogBtn);
         this._switchBtn1 = ComponentFactory.Instance.creatComponentByStylename("core.switchBtn1");
         this._switchBtn1.selected = SharedManager.Instance.autoSnsSend;
         if(!this._switchBtn1.selected)
         {
            this._switchBtn1.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn1.tipData1");
         }
         else
         {
            this._switchBtn1.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn1.tipData2");
         }
         addChild(this._switchBtn1);
         this._switchBtn2 = ComponentFactory.Instance.creatComponentByStylename("core.switchBtn2");
         this._switchBtn2.selected = SharedManager.Instance.allowSnsSend;
         if(!this._switchBtn2.selected)
         {
            this._switchBtn2.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn2.tipData1");
         }
         else
         {
            this._switchBtn2.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn2.tipData2");
         }
         addChild(this._switchBtn2);
         if(!(PathManager.CommnuntyMicroBlog() && PathManager.CommnuntySinaSecondMicroBlog()))
         {
            this._InviteBlogBtn.visible = false;
            this._upPageBtn.x = 22;
            this._downPageBtn.x = 100;
            this._switchBtn1.x = 186;
            this._switchBtn2.x = 214;
         }
         this.initTitle();
         this.updatePageBtnState();
      }
      
      private function initTitle() : void
      {
         this._titleInfo = new FriendListPlayer();
         this._titleInfo.type = 0;
         this._titleInfo.titleType = 0;
         this._titleInfo.titleIsSelected = false;
         this._titleInfo.titleNumText = "";
         this._titleInfo.titleText = LanguageMgr.GetTranslation("im.CMFriendList.title");
         this._title = new IMListItemView();
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("IM.CMFriendList.titlePos");
         this._title.setCellValue(this._titleInfo);
         this._title.x = _loc1_.x;
         this._title.y = _loc1_.y;
         addChild(this._title);
         this._titleInfoII = new FriendListPlayer();
         this._titleInfoII.type = 0;
         this._titleInfoII.titleType = 1;
         this._titleInfoII.titleIsSelected = false;
         this._titleInfoII.titleNumText = "";
         this._titleInfoII.titleText = LanguageMgr.GetTranslation("im.CMFriendList.titleII");
         this._titleII = new IMListItemView();
         this._titleII.setCellValue(this._titleInfoII);
         addChild(this._titleII);
         this._currentTitleInfo = this._titleInfo;
         if(PlayerManager.Instance.CMFriendList)
         {
            this.creatItem();
            this.updateList();
         }
         else
         {
            this.updateListPos();
         }
         if(PathManager.CommnuntyMicroBlog() && PathManager.CommnuntySinaSecondMicroBlog())
         {
            this._titleII.visible = false;
         }
      }
      
      private function initEvent() : void
      {
         this._title.addEventListener(MouseEvent.CLICK,this.__titleClick);
         this._titleII.addEventListener(MouseEvent.CLICK,this.__titleClick);
         this._upPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._downPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._InviteBlogBtn.addEventListener(MouseEvent.CLICK,this.__inviteBolg);
         this._switchBtn1.addEventListener(MouseEvent.CLICK,this.__switchBtn1Click);
         this._switchBtn2.addEventListener(MouseEvent.CLICK,this.__switchBtn2Click);
      }
      
      private function __pageBtnClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget == this._upPageBtn)
         {
            if(this._currentTitleInfo.titleType == 0 && this._currentTitleInfo.titleIsSelected)
            {
               --this._playCurrentPage;
            }
            else if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected)
            {
               --this._unplayCurrentPage;
            }
         }
         else if(param1.currentTarget == this._downPageBtn)
         {
            if(this._currentTitleInfo.titleType == 0 && this._currentTitleInfo.titleIsSelected)
            {
               ++this._playCurrentPage;
            }
            else if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected)
            {
               ++this._unplayCurrentPage;
            }
         }
         this.updateItem();
         SoundManager.instance.play("008");
         this.updatePageBtnState();
      }
      
      private function __inviteBolg(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ExternalInterface.available)
         {
            ExternalInterface.call("showInviteBox",PlayerManager.Instance.Self.ZoneID,PlayerManager.Instance.Self.ID);
         }
      }
      
      private function updatePageBtnState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this._upPageBtn.enable = this._downPageBtn.enable = false;
         if(this._currentTitleInfo.titleType == 0 && this._currentTitleInfo.titleIsSelected)
         {
            _loc1_ = this._playCurrentPage;
            _loc2_ = this._playDDTListTotalPage;
         }
         else if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected)
         {
            _loc1_ = this._unplayCurrentPage;
            _loc2_ = this._unplayDDTListTotalPage;
         }
         if(_loc2_ > 1)
         {
            if(_loc1_ > 0 && _loc1_ < _loc2_ - 1)
            {
               this._upPageBtn.enable = this._downPageBtn.enable = true;
            }
            else if(_loc1_ <= 0 && _loc1_ < _loc2_ - 1)
            {
               this._downPageBtn.enable = true;
            }
            else if(_loc1_ > 0 && _loc1_ >= _loc2_ - 1)
            {
               this._upPageBtn.enable = true;
            }
         }
      }
      
      private function __titleClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if((param1.currentTarget as IMListItemView).getCellValue() == this._currentTitleInfo)
         {
            this._currentTitleInfo.titleIsSelected = !this._currentTitleInfo.titleIsSelected;
         }
         else
         {
            this._currentTitleInfo.titleIsSelected = false;
            this._currentTitleInfo = (param1.currentTarget as IMListItemView).getCellValue();
            this._currentTitleInfo.titleIsSelected = true;
         }
         this._title.setCellValue(this._titleInfo);
         this._titleII.setCellValue(this._titleInfoII);
         this.updateList();
         this.updatePageBtnState();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function updateList() : void
      {
         if(this._currentTitleInfo.titleType == 0 && this._currentTitleInfo.titleIsSelected)
         {
            this._list.visible = true;
            this.updatePlayDDTList();
         }
         else if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected)
         {
            this._list.visible = true;
            this.updateUnPlayDDTList();
         }
         else if(!this._currentTitleInfo.titleIsSelected)
         {
            if(this._currentCMFInfo)
            {
               this._currentCMFInfo.isSelected = false;
            }
            this._list.visible = false;
            this.updateListPos();
         }
      }
      
      private function updatePlayDDTList() : void
      {
         this._CMFriendArray = [];
         this._CMFriendArray = PlayerManager.Instance.PlayCMFriendList;
         if(!this._CMFriendArray)
         {
            return;
         }
         this._playDDTListTotalPage = Math.ceil(this._CMFriendArray.length / LIST_MAX_NUM);
         this.updateItem();
      }
      
      private function updateUnPlayDDTList() : void
      {
         this._CMFriendArray = [];
         this._CMFriendArray = PlayerManager.Instance.UnPlayCMFriendList;
         if(!this._CMFriendArray)
         {
            return;
         }
         this._unplayDDTListTotalPage = Math.ceil(this._CMFriendArray.length / LIST_MAX_NUM);
         this.updateItem();
      }
      
      private function creatItem() : void
      {
         var _loc2_:CMFriendItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < LIST_MAX_NUM)
         {
            _loc2_ = new CMFriendItem();
            _loc2_.addEventListener(MouseEvent.CLICK,this.__itemClick);
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
            this._list.addChild(_loc2_);
            this._CMFriendItemArray.push(_loc2_);
            _loc1_++;
         }
         this.updateListPos();
      }
      
      private function updateItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(this._currentTitleInfo.titleType == 0)
         {
            _loc1_ = this._playCurrentPage * LIST_MAX_NUM;
            _loc2_ = this._playCurrentPage * LIST_MAX_NUM + LIST_MAX_NUM - 1;
            _loc3_ = 0;
            _loc4_ = _loc1_;
            while(_loc4_ <= _loc2_)
            {
               if(this._CMFriendArray[_loc4_] as CMFriendInfo && this._CMFriendItemArray[_loc3_])
               {
                  this._CMFriendItemArray[_loc3_].visible = true;
                  this._CMFriendItemArray[_loc3_].info = this._CMFriendArray[_loc4_] as CMFriendInfo;
               }
               else if(this._CMFriendItemArray[_loc3_])
               {
                  this._CMFriendItemArray[_loc3_].visible = false;
               }
               _loc3_++;
               _loc4_++;
            }
         }
         else if(this._currentTitleInfo.titleType == 1)
         {
            _loc5_ = this._unplayCurrentPage * LIST_MAX_NUM;
            _loc6_ = this._unplayCurrentPage * LIST_MAX_NUM + LIST_MAX_NUM - 1;
            _loc7_ = 0;
            _loc8_ = _loc5_;
            while(_loc8_ <= _loc6_)
            {
               if(this._CMFriendArray[_loc8_] as CMFriendInfo && this._CMFriendItemArray[_loc3_])
               {
                  this._CMFriendItemArray[_loc7_].visible = true;
                  this._CMFriendItemArray[_loc7_].info = this._CMFriendArray[_loc8_] as CMFriendInfo;
               }
               else if(this._CMFriendItemArray[_loc3_])
               {
                  this._CMFriendItemArray[_loc7_].visible = false;
               }
               _loc7_++;
               _loc8_++;
            }
         }
         this.updateListPos();
      }
      
      private function updateListPos() : void
      {
         if(this._currentTitleInfo.titleType == 0 && this._currentTitleInfo.titleIsSelected)
         {
            this._list.y = this._title.y + this._title.height - 7;
            this._titleII.y = this._list.y + this._list.height - 3;
         }
         else if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected)
         {
            this._titleII.y = this._title.y + this._title.height - 7;
            this._list.y = this._titleII.y + this._titleII.height - 7;
         }
         else
         {
            this._titleII.y = this._title.y + this._title.height - 7;
         }
      }
      
      private function cleanItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._CMFriendItemArray.length)
         {
            (this._CMFriendItemArray[_loc1_] as CMFriendItem).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._CMFriendItemArray[_loc1_] as CMFriendItem).removeEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
            (this._CMFriendItemArray[_loc1_] as CMFriendItem).removeEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
            (this._CMFriendItemArray[_loc1_] as CMFriendItem).dispose();
            _loc1_++;
         }
         this._list.disposeAllChildren();
         this._CMFriendItemArray = [];
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentCMFInfo)
         {
            this._currentCMFInfo = (param1.currentTarget as CMFriendItem).info;
            this._currentCMFInfo.isSelected = true;
         }
         else
         {
            if(this._currentCMFInfo == (param1.currentTarget as CMFriendItem).info)
            {
               return;
            }
            this._currentCMFInfo.isSelected = false;
            this._currentCMFInfo = (param1.currentTarget as CMFriendItem).info;
            this._currentCMFInfo.isSelected = true;
         }
         this.updateItem();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function __itemOut(param1:MouseEvent) : void
      {
         this.resetItem();
         (param1.currentTarget as CMFriendItem).itemOut();
      }
      
      private function __itemOver(param1:MouseEvent) : void
      {
         this.resetItem();
         (param1.currentTarget as CMFriendItem).itemOver();
      }
      
      private function resetItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._CMFriendItemArray.length)
         {
            (this._CMFriendItemArray[_loc1_] as CMFriendItem).itemOut();
            _loc1_++;
         }
      }
      
      public function get currentCMFInfo() : CMFriendInfo
      {
         return this._currentCMFInfo;
      }
      
      public function get currentTitleInfo() : FriendListPlayer
      {
         return this._currentTitleInfo;
      }
      
      protected function __switchBtn1Click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.autoSnsSend = this._switchBtn1.selected;
         if(!this._switchBtn1.selected)
         {
            this._switchBtn1.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn1.tipData1");
         }
         else
         {
            this._switchBtn1.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn1.tipData2");
         }
      }
      
      protected function __switchBtn2Click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.allowSnsSend = this._switchBtn2.selected;
         if(!this._switchBtn2.selected)
         {
            this._switchBtn2.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn2.tipData1");
         }
         else
         {
            this._switchBtn2.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn2.tipData2");
         }
      }
      
      public function dispose() : void
      {
         this.cleanItem();
         if(this._list && this._list.parent)
         {
            this._list.parent.removeChild(this._list);
            this._list.dispose();
            this._list = null;
         }
         if(this._title && this._title.parent)
         {
            this._title.removeEventListener(MouseEvent.CLICK,this.__titleClick);
            this._title.parent.removeChild(this._title);
            this._title.dispose();
            this._title = null;
         }
         if(this._titleII && this._titleII.parent)
         {
            this._titleII.removeEventListener(MouseEvent.CLICK,this.__titleClick);
            this._titleII.parent.removeChild(this._titleII);
            this._titleII.dispose();
            this._titleII = null;
         }
         if(this._upPageBtn && this._upPageBtn.parent)
         {
            this._upPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
            this._upPageBtn.parent.removeChild(this._upPageBtn);
            this._upPageBtn.dispose();
            this._upPageBtn = null;
         }
         if(this._downPageBtn && this._downPageBtn.parent)
         {
            this._downPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
            this._downPageBtn.parent.removeChild(this._downPageBtn);
            this._downPageBtn.dispose();
            this._downPageBtn = null;
         }
         if(this._InviteBlogBtn)
         {
            this._InviteBlogBtn.removeEventListener(MouseEvent.CLICK,this.__inviteBolg);
            ObjectUtils.disposeObject(this._InviteBlogBtn);
            this._InviteBlogBtn = null;
         }
         if(this._switchBtn1 && this._switchBtn1.parent)
         {
            this._switchBtn1.removeEventListener(MouseEvent.CLICK,this.__switchBtn1Click);
            this._switchBtn1.parent.removeChild(this._switchBtn1);
            this._switchBtn1.dispose();
            this._switchBtn1 = null;
         }
         if(this._switchBtn2 && this._switchBtn2.parent)
         {
            this._switchBtn2.removeEventListener(MouseEvent.CLICK,this.__switchBtn2Click);
            this._switchBtn2.parent.removeChild(this._switchBtn2);
            this._switchBtn2.dispose();
            this._switchBtn2 = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
