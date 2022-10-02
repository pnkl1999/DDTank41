package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.utils.StringHelper;
   
   public class MemberList extends Sprite implements Disposeable
   {
       
      
      private var _name:BaseButton;
      
      private var _job:BaseButton;
      
      private var _level:BaseButton;
      
      private var _offer:BaseButton;
      
      private var _fightPower:BaseButton;
      
      private var _offLine:BaseButton;
      
      private var _search:SimpleBitmapButton;
      
      private var _list:ListPanel;
      
      private var _lastSort:String = "";
      
      private var _isDes:Boolean = false;
      
      private var _searchMemberFrame:SearchMemberFrame;
      
      public function MemberList()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._name = ComponentFactory.Instance.creatComponentByStylename("memberList.name");
         this._job = ComponentFactory.Instance.creatComponentByStylename("memberList.job");
         this._level = ComponentFactory.Instance.creatComponentByStylename("memberList.level");
         this._offer = ComponentFactory.Instance.creatComponentByStylename("memberList.offer");
         this._fightPower = ComponentFactory.Instance.creatComponentByStylename("memberList.fightPower");
         this._offLine = ComponentFactory.Instance.creatComponentByStylename("memberList.offLine");
         this._list = ComponentFactory.Instance.creatComponentByStylename("memberList.list");
         this._search = ComponentFactory.Instance.creatComponentByStylename("memberList.searchBtn");
         addChild(this._name);
         addChild(this._job);
         addChild(this._level);
         addChild(this._offer);
         addChild(this._fightPower);
         addChild(this._offLine);
         addChild(this._list);
         addChild(this._search);
         this.setTip(this._name,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.name"));
         this.setTip(this._job,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.duty"));
         this.setTip(this._level,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.level"));
         this.setTip(this._offer,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.contribute"));
         this.setTip(this._fightPower,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.battle"));
         this.setTip(this._offLine,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.time"));
         this.setTip(this._search,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.search"));
         this.setListData();
      }
      
      private function setTip(param1:BaseButton, param2:String) : void
      {
         param1.tipStyle = "ddt.view.tips.OneLineTip";
         param1.tipDirctions = "0";
         param1.tipData = param2;
      }
      
      private function initEvent() : void
      {
         this._name.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._job.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._level.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._offer.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._fightPower.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._offLine.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._search.addEventListener(MouseEvent.CLICK,this.__showSearchFrame);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBERLIST_COMPLETE,this.__listLoadCompleteHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_ADD,this.__addMemberHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_REMOVE,this.__removeMemberHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_UPDATA,this.__updataMemberHandler);
      }
      
      private function removeEvent() : void
      {
         this._name.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._job.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._level.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._offer.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._fightPower.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._offLine.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._search.removeEventListener(MouseEvent.CLICK,this.__showSearchFrame);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBERLIST_COMPLETE,this.__listLoadCompleteHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_ADD,this.__addMemberHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_REMOVE,this.__removeMemberHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_UPDATA,this.__updataMemberHandler);
         if(this._searchMemberFrame)
         {
            this._searchMemberFrame.removeEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
         }
      }
      
      public function __updataMemberHandler(param1:ConsortionEvent) : void
      {
         var _loc5_:ConsortiaPlayerInfo = null;
         var _loc2_:ConsortiaPlayerInfo = param1.data as ConsortiaPlayerInfo;
         var _loc3_:int = this._list.vectorListModel.elements.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._list.vectorListModel.elements[_loc4_] as ConsortiaPlayerInfo;
            if(_loc5_.ID == _loc2_.ID)
            {
               _loc5_ = _loc2_;
               break;
            }
            _loc4_++;
         }
         this._list.list.updateListView();
      }
      
      public function __addMemberHandler(param1:ConsortionEvent) : void
      {
         var _loc2_:int = ConsortionModelControl.Instance.model.memberList.length;
         this._list.vectorListModel.append(param1.data as ConsortiaPlayerInfo,_loc2_ - 1);
         if(_loc2_ <= 6)
         {
            this._list.vectorListModel.removeElementAt(this._list.vectorListModel.elements.length - 1);
         }
         this._list.list.updateListView();
      }
      
      public function __removeMemberHandler(param1:ConsortionEvent) : void
      {
         this._list.vectorListModel.remove(param1.data as ConsortiaPlayerInfo);
         var _loc2_:int = ConsortionModelControl.Instance.model.memberList.length;
         if(_loc2_ < 6)
         {
            this.setListData();
         }
         this._list.list.updateListView();
      }
      
      private function __btnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._isDes = !!this._isDes ? Boolean(Boolean(false)) : Boolean(Boolean(true));
         switch(param1.currentTarget)
         {
            case this._name:
               this._lastSort = "NickName";
               break;
            case this._job:
               this._lastSort = "DutyLevel";
               break;
            case this._level:
               this._lastSort = "Grade";
               break;
            case this._offer:
               this._lastSort = "UseOffer";
               break;
            case this._fightPower:
               this._lastSort = "FightPower";
               break;
            case this._offLine:
               this._lastSort = "OffLineHour";
         }
         this.sortOnItem(this._lastSort,this._isDes);
      }
      
      private function __listLoadCompleteHandler(param1:ConsortionEvent) : void
      {
         this.setListData();
      }
      
      private function __showSearchFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._searchMemberFrame && this._searchMemberFrame.parent)
         {
            return;
         }
         this._searchMemberFrame = ComponentFactory.Instance.creatComponentByStylename("SearchMemberFrame");
         this._searchMemberFrame.addEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
         LayerManager.Instance.addToLayer(this._searchMemberFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         this._searchMemberFrame.setFocus();
      }
      
      private function __onFrameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(this.search(this._searchMemberFrame.getSearchText()))
               {
                  this.hideSearchFrame();
               }
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
               this.hideSearchFrame();
         }
      }
      
      private function search(param1:String) : Boolean
      {
         var _loc8_:ConsortiaPlayerInfo = null;
         if(FilterWordManager.isGotForbiddenWords(param1))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.warningII"));
            return false;
         }
         if(param1 == LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.default") || param1 == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.default"));
            return false;
         }
         if(StringHelper.getIsBiggerMaxCHchar(param1,7))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.warningII"));
            return false;
         }
         var _loc2_:String = param1;
         var _loc3_:Array = ConsortionModelControl.Instance.model.memberList.list;
         var _loc4_:Array = [];
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc8_ = _loc3_[_loc6_];
            if(_loc8_.NickName.indexOf(_loc2_) != -1)
            {
               _loc4_.unshift(_loc8_);
               _loc5_ = true;
            }
            else
            {
               _loc4_.push(_loc8_);
            }
            _loc6_++;
         }
         if(_loc2_ == LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.warningII"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.default"));
            return false;
         }
         if(!_loc5_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.warningII"));
            return false;
         }
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(_loc4_);
         var _loc7_:int = _loc4_.length;
         if(_loc7_ < 6)
         {
            while(_loc7_ < 6)
            {
               this._list.vectorListModel.append(null,_loc7_);
               _loc7_++;
            }
         }
         this._list.list.updateListView();
         return true;
      }
      
      private function hideSearchFrame() : void
      {
         if(this._searchMemberFrame)
         {
            this._searchMemberFrame.removeEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
            ObjectUtils.disposeObject(this._searchMemberFrame);
            this._searchMemberFrame = null;
         }
      }
      
      private function setListData() : void
      {
         var _loc1_:int = 0;
         if(ConsortionModelControl.Instance.model.memberList.length > 0)
         {
            this._list.vectorListModel.clear();
            this._list.vectorListModel.appendAll(ConsortionModelControl.Instance.model.memberList.list);
            _loc1_ = ConsortionModelControl.Instance.model.memberList.length;
            if(_loc1_ < 6)
            {
               while(_loc1_ < 6)
               {
                  this._list.vectorListModel.append(null,_loc1_);
                  _loc1_++;
               }
            }
            if(this._lastSort == "")
            {
               this._lastSort = "Init";
               this._isDes = false;
            }
            this.sortOnItem(this._lastSort,this._isDes);
         }
      }
      
      private function sortOnItem(param1:String, param2:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = ConsortionModelControl.Instance.model.memberList.length;
         if(_loc3_ < 6)
         {
            this._list.vectorListModel.elements.splice(_loc3_,6 - _loc3_ + 1);
         }
         if(param1 == "Init")
         {
            this._list.vectorListModel.elements.sortOn("Grade",2 | 1 | 16);
            _loc4_ = 0;
            while(_loc4_ < this._list.vectorListModel.elements.length)
            {
               if(this._list.vectorListModel.elements[_loc4_] && this._list.vectorListModel.elements[_loc4_].ID == PlayerManager.Instance.Self.ID)
               {
                  this._list.vectorListModel.elements.unshift(this._list.vectorListModel.elements[_loc4_]);
                  this._list.vectorListModel.elements.splice(_loc4_ + 1,1);
               }
               _loc4_++;
            }
         }
         else
         {
            this._list.vectorListModel.elements.sortOn(param1,2 | 1 | 16);
         }
         if(param2)
         {
            this._list.vectorListModel.elements.reverse();
         }
         if(_loc3_ < 6)
         {
            while(_loc3_ < 6)
            {
               this._list.vectorListModel.append(null,_loc3_);
               _loc3_++;
            }
         }
         this._list.list.updateListView();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._list.vectorListModel.clear();
         if(this._list)
         {
            this._list.dispose();
         }
         this._list = null;
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._searchMemberFrame);
         this._searchMemberFrame = null;
         this._name = null;
         this._job = null;
         this._level = null;
         this._offer = null;
         this._fightPower = null;
         this._offLine = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
