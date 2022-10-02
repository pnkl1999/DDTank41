package consortion
{
   import consortion.data.ConsortiaApplyInfo;
   import consortion.data.ConsortiaAssetLevelOffer;
   import consortion.data.ConsortiaDutyInfo;
   import consortion.data.ConsortiaInventData;
   import consortion.data.ConsortiaLevelInfo;
   import consortion.data.ConsortionPollInfo;
   import consortion.data.ConsortionSkillInfo;
   import consortion.event.ConsortionEvent;
   import ddt.data.ConsortiaEventInfo;
   import ddt.data.ConsortiaInfo;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class ConsortionModel extends EventDispatcher
   {
      
      public static const CONSORTION_MAX_LEVEL:int = 10;
      
      public static const SHOP_MAX_LEVEL:int = 5;
      
      public static const STORE_MAX_LEVEL:int = 10;
      
      public static const BANK_MAX_LEVEL:int = 10;
      
      public static const SKILL_MAX_LEVEL:int = 10;
      
      public static const LEVEL:int = 0;
      
      public static const SHOP:int = 1;
      
      public static const STORE:int = 2;
      
      public static const BANK:int = 3;
      
      public static const SKILL:int = 4;
      
      public static const CONSORTION_SKILL:int = 1;
      
      public static const PERSONAL_SKILL:int = 2;
      
      public static const CLUB:String = "consortiaClub";
      
      public static const SELF_CONSORTIA:String = "selfConsortia";
      
      public static const ConsortionListEachPageNum:int = 6;
       
      
      public var systemDate:String;
      
      private var _memberList:DictionaryData;
      
      private var _consortionList:Vector.<ConsortiaInfo>;
      
      public var consortionsListTotalCount:int;
      
      private var _myApplyList:Vector.<ConsortiaApplyInfo>;
      
      public var applyListTotalCount:int;
      
      private var _inventList:Vector.<ConsortiaInventData>;
      
      public var inventListTotalCount:int;
      
      private var _eventList:Vector.<ConsortiaEventInfo>;
      
      private var _useConditionList:Vector.<ConsortiaAssetLevelOffer>;
      
      private var _dutyList:Vector.<ConsortiaDutyInfo>;
      
      private var _pollList:Vector.<ConsortionPollInfo>;
      
      private var _skillInfoList:Vector.<ConsortionSkillInfo>;
      
      private var _levelUpData:Vector.<ConsortiaLevelInfo>;
      
      public function ConsortionModel(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function get memberList() : DictionaryData
      {
         if(this._memberList == null)
         {
            this._memberList = new DictionaryData();
         }
         return this._memberList;
      }
      
      public function set memberList(param1:DictionaryData) : void
      {
         if(this._memberList == param1)
         {
            return;
         }
         this._memberList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBERLIST_COMPLETE));
      }
      
      public function addMember(param1:ConsortiaPlayerInfo) : void
      {
         this._memberList.add(param1.ID,param1);
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBER_ADD,param1));
      }
      
      public function removeMember(param1:ConsortiaPlayerInfo) : void
      {
         this._memberList.remove(param1.ID);
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBER_REMOVE,param1));
      }
      
      public function updataMember(param1:ConsortiaPlayerInfo) : void
      {
         this._memberList.add(param1.ID,param1);
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBER_UPDATA,param1));
      }
      
      public function get onlineConsortiaMemberList() : Array
      {
         var _loc2_:ConsortiaPlayerInfo = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.memberList)
         {
            if(_loc2_.playerState.StateID != PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getConsortiaMemberInfo(param1:int) : ConsortiaPlayerInfo
      {
         var _loc2_:ConsortiaPlayerInfo = null;
         for each(_loc2_ in this.memberList)
         {
            if(_loc2_.ID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get offlineConsortiaMemberList() : Array
      {
         var _loc2_:ConsortiaPlayerInfo = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.memberList)
         {
            if(_loc2_.playerState.StateID == PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function consortiaPlayerStateChange(param1:int, param2:int) : void
      {
         var _loc4_:PlayerState = null;
         var _loc3_:ConsortiaPlayerInfo = this.getConsortiaMemberInfo(param1);
         if(_loc3_ == null)
         {
            return;
         }
         if(_loc3_)
         {
            _loc4_ = new PlayerState(param2);
            _loc3_.playerState = _loc4_;
            this.updataMember(_loc3_);
         }
      }
      
      public function set consortionList(param1:Vector.<ConsortiaInfo>) : void
      {
         if(this._consortionList == param1)
         {
            return;
         }
         this._consortionList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTIONLIST_IS_CHANGE));
      }
      
      public function get consortionList() : Vector.<ConsortiaInfo>
      {
         return this._consortionList;
      }
      
      public function set myApplyList(param1:Vector.<ConsortiaApplyInfo>) : void
      {
         if(this._myApplyList == param1)
         {
            return;
         }
         this._myApplyList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE));
      }
      
      public function get myApplyList() : Vector.<ConsortiaApplyInfo>
      {
         return this._myApplyList;
      }
      
      public function getapplyListWithPage(param1:int, param2:int = 10) : Vector.<ConsortiaApplyInfo>
      {
         param1 = param1 < 0 ? int(int(1)) : (param1 > Math.ceil(this._myApplyList.length / param2) ? int(int(Math.ceil(this._myApplyList.length / param2))) : int(int(param1)));
         return this.myApplyList.slice((param1 - 1) * param2,param1 * param2);
      }
      
      public function deleteOneApplyRecord(param1:int) : void
      {
         var _loc2_:int = this.myApplyList.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.myApplyList[_loc3_].ID == param1)
            {
               this.myApplyList.splice(_loc3_,1);
               dispatchEvent(new ConsortionEvent(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE));
               break;
            }
            _loc3_++;
         }
      }
      
      public function set inventList(param1:Vector.<ConsortiaInventData>) : void
      {
         if(this._inventList == param1)
         {
            return;
         }
         this._inventList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.INVENT_LIST_IS_CHANGE));
      }
      
      public function get inventList() : Vector.<ConsortiaInventData>
      {
         return this._inventList;
      }
      
      public function get eventList() : Vector.<ConsortiaEventInfo>
      {
         return this._eventList;
      }
      
      public function set eventList(param1:Vector.<ConsortiaEventInfo>) : void
      {
         if(this._eventList == param1)
         {
            return;
         }
         this._eventList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.EVENT_LIST_CHANGE));
      }
      
      public function get useConditionList() : Vector.<ConsortiaAssetLevelOffer>
      {
         return this._useConditionList;
      }
      
      public function set useConditionList(param1:Vector.<ConsortiaAssetLevelOffer>) : void
      {
         if(this._useConditionList == param1)
         {
            return;
         }
         this._useConditionList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.USE_CONDITION_CHANGE));
      }
      
      public function get dutyList() : Vector.<ConsortiaDutyInfo>
      {
         return this._dutyList;
      }
      
      public function set dutyList(param1:Vector.<ConsortiaDutyInfo>) : void
      {
         if(this._dutyList == param1)
         {
            return;
         }
         this._dutyList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.DUTY_LIST_CHANGE));
      }
      
      public function changeDutyListName(param1:int, param2:String) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._dutyList.length)
         {
            if(this._dutyList[_loc3_].DutyID == param1)
            {
               this._dutyList[_loc3_].DutyName = param2;
               break;
            }
            _loc3_++;
         }
      }
      
      public function get pollList() : Vector.<ConsortionPollInfo>
      {
         return this._pollList;
      }
      
      public function set pollList(param1:Vector.<ConsortionPollInfo>) : void
      {
         if(this._pollList == param1)
         {
            return;
         }
         this._pollList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.POLL_LIST_CHANGE));
      }
      
      public function get skillInfoList() : Vector.<ConsortionSkillInfo>
      {
         return this._skillInfoList;
      }
      
      public function set skillInfoList(param1:Vector.<ConsortionSkillInfo>) : void
      {
         if(this._skillInfoList == param1)
         {
            return;
         }
         this._skillInfoList = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.SKILL_LIST_CHANGE));
      }
      
      public function getskillInfoWithTypeAndLevel(param1:int, param2:int) : Vector.<ConsortionSkillInfo>
      {
         var _loc3_:Vector.<ConsortionSkillInfo> = new Vector.<ConsortionSkillInfo>();
         var _loc4_:int = this.skillInfoList.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.skillInfoList[_loc5_].type == param1 && this.skillInfoList[_loc5_].level == param2)
            {
               _loc3_.push(this.skillInfoList[_loc5_]);
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function getSkillInfoByID(param1:int) : ConsortionSkillInfo
      {
         var _loc2_:ConsortionSkillInfo = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.skillInfoList.length)
         {
            if(this.skillInfoList[_loc3_].id == param1)
            {
               _loc2_ = this.skillInfoList[_loc3_];
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function updateSkillInfo(param1:int, param2:Boolean, param3:Date, param4:int) : void
      {
         var _loc5_:int = this.skillInfoList.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(this.skillInfoList[_loc6_].id == param1)
            {
               this.skillInfoList[_loc6_].isOpen = param2;
               this.skillInfoList[_loc6_].beginDate = param3;
               this.skillInfoList[_loc6_].validDate = param4;
               break;
            }
            _loc6_++;
         }
      }
      
      public function hasSomeGroupSkill(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = this.skillInfoList.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.skillInfoList[_loc4_].group == param1 && this.skillInfoList[_loc4_].isOpen && this.skillInfoList[_loc4_].id != param2)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function set levelUpData(param1:Vector.<ConsortiaLevelInfo>) : void
      {
         if(this._levelUpData == param1)
         {
            return;
         }
         this._levelUpData = param1;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.LEVEL_UP_RULE_CHANGE));
      }
      
      public function get levelUpData() : Vector.<ConsortiaLevelInfo>
      {
         return this._levelUpData;
      }
      
      public function getLevelData(param1:int) : ConsortiaLevelInfo
      {
         if(this.levelUpData == null)
         {
            return null;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.levelUpData.length)
         {
            if(this.levelUpData[_loc2_]["Level"] == param1)
            {
               return this.levelUpData[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getLevelString(param1:int, param2:int) : Vector.<String>
      {
         var _loc3_:Vector.<String> = new Vector.<String>(4);
         switch(param1)
         {
            case LEVEL:
               if(param2 >= CONSORTION_MAX_LEVEL)
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.explainTxt",this.getLevelData(param2).Count);
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.upgrade",this.getLevelData(param2).Count);
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.nextLevel",param2 + 1,this.getLevelData(param2 + 1).Count);
                  _loc3_[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consumeTxt",String(this.getLevelData(param2 + 1).Riches),this.checkRiches(this.getLevelData(param2 + 1).Riches),this.getLevelData(param2 + 1).NeedGold) + this.checkGold(this.getLevelData(param2 + 1).NeedGold);
               }
               _loc3_[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               break;
            case SHOP:
               if(param2 >= SHOP_MAX_LEVEL)
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaShopLevel");
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASHOPGRADE.explainTxt");
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopView.titleText") + (param2 + 1) + LanguageMgr.GetTranslation("grade");
                  _loc3_[2] = LanguageMgr.GetTranslation("consortia.upgrade") + (param2 + 1) * 2 + LanguageMgr.GetTranslation("grade");
                  if(this.getLevelData(param2 + 1))
                  {
                     _loc3_[3] = this.getLevelData(param2 + 1).ShopRiches + LanguageMgr.GetTranslation("consortia.Money") + this.checkRiches(this.getLevelData(param2 + 1).ShopRiches);
                  }
               }
               break;
            case STORE:
               if(param2 >= STORE_MAX_LEVEL)
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.store");
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.success") + param2 * 10 + "%";
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.storeSuccess",param2 + 1,(param2 + 1) * 10 + "%");
                  _loc3_[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.appealTxt",param2 + 1);
                  if(this.getLevelData(param2 + 1))
                  {
                     _loc3_[3] = this.getLevelData(param2 + 1).SmithRiches + LanguageMgr.GetTranslation("consortia.Money") + this.checkRiches(this.getLevelData(param2 + 1).SmithRiches);
                  }
               }
               break;
            case BANK:
               if(param2 >= BANK_MAX_LEVEL)
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.bank");
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.contentUpgrade",param2 * 10);
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.contentSmith",param2 + 1,(param2 + 1) * 10);
                  _loc3_[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.appealTxt",param2 + 1);
                  if(this.getLevelData(param2 + 1))
                  {
                     _loc3_[3] = this.getLevelData(param2 + 1).StoreRiches + LanguageMgr.GetTranslation("consortia.Money") + this.checkRiches(this.getLevelData(param2 + 1).StoreRiches);
                  }
               }
               break;
            case SKILL:
               if(param2 >= SKILL_MAX_LEVEL)
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.skill");
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  _loc3_[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  _loc3_[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.skill.explainTxt");
                  _loc3_[1] = LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopView.skill",param2 + 1);
                  _loc3_[2] = LanguageMgr.GetTranslation("consortia.upgrade") + (param2 + 1) + LanguageMgr.GetTranslation("grade");
                  if(this.getLevelData(param2 + 1))
                  {
                     _loc3_[3] = this.getLevelData(param2 + 1).BufferRiches + LanguageMgr.GetTranslation("consortia.Money") + this.checkRiches(this.getLevelData(param2 + 1).BufferRiches);
                  }
               }
         }
         return _loc3_;
      }
      
      public function checkConsortiaRichesForUpGrade(param1:int) : Boolean
      {
         var _loc2_:int = PlayerManager.Instance.Self.consortiaInfo.Riches;
         switch(param1)
         {
            case 0:
               if(PlayerManager.Instance.Self.consortiaInfo.Level < CONSORTION_MAX_LEVEL)
               {
                  if(_loc2_ < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level + 1).Riches)
                  {
                     return false;
                  }
               }
               break;
            case 2:
               if(PlayerManager.Instance.Self.consortiaInfo.ShopLevel < SHOP_MAX_LEVEL)
               {
                  if(_loc2_ < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.ShopLevel + 1).ShopRiches)
                  {
                     return false;
                  }
               }
               break;
            case 3:
               if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel < BANK_MAX_LEVEL)
               {
                  if(_loc2_ < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.StoreLevel + 1).StoreRiches)
                  {
                     return false;
                  }
               }
               break;
            case 1:
               if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel < STORE_MAX_LEVEL)
               {
                  if(_loc2_ < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.SmithLevel + 1).SmithRiches)
                  {
                     return false;
                  }
               }
               break;
            case 4:
               if(PlayerManager.Instance.Self.consortiaInfo.BufferLevel < SKILL_MAX_LEVEL)
               {
                  if(_loc2_ < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.BufferLevel + 1).BufferRiches)
                  {
                     return false;
                  }
               }
         }
         return true;
      }
      
      private function checkRiches(param1:int) : String
      {
         var _loc2_:String = "";
         if(PlayerManager.Instance.Self.consortiaInfo.Riches < param1)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.condition");
         }
         return _loc2_;
      }
      
      private function checkGold(param1:int) : String
      {
         var _loc2_:String = "";
         if(PlayerManager.Instance.Self.Gold < param1)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.condition");
         }
         return _loc2_;
      }
   }
}
